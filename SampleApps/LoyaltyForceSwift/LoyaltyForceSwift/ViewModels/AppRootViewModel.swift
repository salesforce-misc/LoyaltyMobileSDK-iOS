//
//  EnrollmentViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

import Foundation
import Firebase

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
    
    @Published var enrolledMember: EnrollmentOutputModel?
    
    @Published var isInProgress = false
    @Published var userErrorMessage = ("", ErrorType.noError)
    @Published var userState = UserState.none
    
    var email = ""
    var oobCode = ""
    var apiKey = ""
    
    func signUpUser(userEmail: String, userPassword: String, firstName: String, lastName: String) {
        
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
                        self?.enrolledMember = try await LoyaltyAPIManager.shared.postEnrollment(firstName: firstName, lastName: lastName, email: userEmail)
                        if let member = self?.enrolledMember {
                            print(member)
                        }
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
                        self?.isInProgress = false
                        self?.userState = .signedIn
                    } catch {
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
