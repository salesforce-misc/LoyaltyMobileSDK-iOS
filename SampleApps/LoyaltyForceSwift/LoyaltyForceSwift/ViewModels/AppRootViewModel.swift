//
//  EnrollmentViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

import Foundation
import Firebase
import SwiftUI

enum ErrorType: Hashable {
    case signUp
    case signIn
    case resetPassword
    case createNewPassword
    case noError
}

enum UserState: Hashable {
    case signedIn
    case signedUp
    case resetPasswordRequested
    case newPasswordSet
    case signedOut
    case none
}

@MainActor
class AppRootViewModel: ObservableObject {
    
    @Published var member: MemberModel?
    
    @Published var isInProgress = false
    @Published var userErrorMessage = ("", ErrorType.noError)
    @Published var userState = UserState.none
    
    @AppStorage("email") var email = ""
    var oobCode = ""
    var apiKey = ""
    
    func signUpUser(userEmail: String,
                    userPassword: String,
                    firstName: String,
                    lastName: String,
                    mobileNumber: String,
                    joinEmailList: Bool) {
        
        isInProgress = true
        email = userEmail
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            
            if let error = error {
                self?.isInProgress = false
                self?.userErrorMessage = (error.localizedDescription, .signUp)
                return
            }

            switch authResult {
            case .none:
                print("<Firebase> - Could not create account.")
                self?.isInProgress = false
            case .some(_):
                print("<Firebase> - User created on Firebase.")
                
                Task {
                    do {
                        try await ForceAuthManager.shared.grantAuth()
                        let enrolledMember = try await LoyaltyAPIManager.shared.postEnrollment(firstName: firstName,
                                                                                               lastName: lastName,
                                                                                               email: userEmail,
                                                                                               phone: mobileNumber,
                                                                                               emailNotification: joinEmailList)
                        
                        let enrollmentDetails = EnrollmentDetails(loyaltyProgramMemberId: enrolledMember.loyaltyProgramMemberId,
                                                                  loyaltyProgramName: enrolledMember.loyaltyProgramName,
                                                                  membershipNumber: enrolledMember.membershipNumber)
                        
                        let member = MemberModel(firstName: firstName,
                                                 lastName: lastName,
                                                 email: userEmail,
                                                 mobileNumber: mobileNumber,
                                                 joinEmailList: joinEmailList,
                                                 dateCreated: Date(),
                                                 enrollmentDetails: enrollmentDetails)
                        self?.member = member
                        
                        // Save member to local disk
                        LocalFileManager.instance.saveData(item: member, id: member.email)
                        
                        // Also backup to a centralized local in case the user deletes the app
                        // then we can retrieve the member info linked to Salesforce
                        try FirestoreManager.addMemberData(member: member)
                        print("<Firestore> - Member info saved.")
                        
                        self?.userState = .signedUp
                        self?.isInProgress = false
                    } catch {
                        self?.userErrorMessage = (error.localizedDescription, .signUp)

                        // Member Enrollment failed, then delete User from Firebase
                        let user = Auth.auth().currentUser

                        user?.delete { error in
                          if let error = error {
                              print("<Firebase> - Could not delete current user. \(error)")
                          } else {
                              print("<Firebase> - User was deleted.")
                          }
                        }
                        self?.isInProgress = false
                        return
                    }

                }
                
            }
            
        }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        isInProgress = true
        email = userEmail
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            
            if let error = error {
                self?.isInProgress = false
                self?.userErrorMessage = (error.localizedDescription, .signIn)
                return
            }
            
            switch authResult {
            case .none:
                print("<Firebase> - Could not sign in user.")
                self?.isInProgress = false
            case .some(_):
                print("<Firebase> - User signed in")
                Task{
                    do {
                        try await ForceAuthManager.shared.grantAuth()                        
                        
                        // Retrieve member data from local disk
                        let member = LocalFileManager.instance.getData(type: MemberModel.self, id: userEmail)
                        
                        if let member = member {
                            self?.member = member
                        } else {
                            // Cannot get the member info from local, may have been deleted by the user
                            // retrieve it from a centralized location, i.e. Firestore
                            let memberReturned = try await FirestoreManager.getMemberData(by: userEmail)
                            print("<Firestore> - Member info retrieved.")
                            self?.member = memberReturned
                            // Save member to local disk
                            LocalFileManager.instance.saveData(item: memberReturned, id: memberReturned.email)
                            
                        }
                        
                        self?.isInProgress = false
                        self?.userState = .signedIn
                    } catch {
                        self?.isInProgress = false
                        self?.userErrorMessage = (error.localizedDescription, .signIn)
                    }
                }
            }
            
        }

    }
    
    func signOutUser() {
        
        isInProgress = true
        
        do {
            try Auth.auth().signOut()
            ForceAuthManager.shared.clearAuth()
            userState = .signedOut
            isInProgress = false
            member = nil
        } catch {
            print("<Firebase> - Error signing out: \(error.localizedDescription)")
            isInProgress = false
        }
    }
    
    func requestResetPassword(userEmail: String) {
        
        isInProgress = true
        
        Auth.auth().sendPasswordReset(withEmail: userEmail) { [weak self] error in
            
            if let error = error {
                self?.isInProgress = false
                self?.userErrorMessage = (error.localizedDescription, .resetPassword)
                return
            }
            
            self?.userState = .resetPasswordRequested
            self?.isInProgress = false
            
        }
    }
    
    // Firebase REST API Endpoint: https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=[API_KEY]
    // Refrence: https://firebase.google.com/docs/reference/rest/auth#section-verify-password-reset-code
    func resetPassword(newPassword: String) async {
        
        isInProgress = true
        
        guard let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=\(apiKey)") else {
            userErrorMessage = (URLError(.badURL).localizedDescription, .createNewPassword)
            return
        }
        let body = [
            "oobCode": oobCode,
            "newPassword": newPassword
        ]
        do {
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = ForceRequest.createRequest(from: url, method: "POST", body: bodyJsonData)
            let result = try await ForceClient.shared.fetch(type: PasswordResetModel.self, with: request)
            email = result.email
            userState = .newPasswordSet
        } catch {
            userErrorMessage = (error.localizedDescription, .createNewPassword)
        }
    }
    
}
