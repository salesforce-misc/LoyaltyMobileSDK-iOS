//
//  AppRootViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/27/22.
//

import Foundation
import SwiftUI
import LoyaltyMobileSDK

enum ErrorType: Hashable {
    case signUp
    case signIn
    case enrollUser
    case resetPassword
    case createNewPassword
    case noError
}

enum UserState: Hashable {
    case signedIn
    case signedInButNotJoined
    case signedUp
    case resetPasswordRequested
    case newPasswordSet
    case signedOut
    case none
}

@MainActor
class AppRootViewModel: ObservableObject {
    
    @Published var member: CommunityMemberModel?
    
    @Published var isInProgress = false
    @Published var userErrorMessage = ("", ErrorType.noError)
    @Published var userState = UserState.none
    
    @AppStorage("email") var email = ""
    var oobCode = ""
    var apiKey = ""
    
    private let authManager = ForceAuthManager.shared
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init() {
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.shared.getInstanceURL(),
                                              forceClient: ForceClient(auth: authManager))
    }
    
    func signUpUser(userEmail: String,
                    userPassword: String,
                    firstName: String,
                    lastName: String,
                    mobileNumber: String,
                    joinEmailList: Bool) {
        
        isInProgress = true
        email = userEmail
        
        // TODO: Need to redo Sign Up since Firebase is removed
        /*
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            
            if let error = error {
                self?.isInProgress = false
                self?.userErrorMessage = (error.localizedDescription, .signUp)
                return
            }

            switch authResult {
            case .none:
                Logger.error("<Firebase> - Could not create account.")
                self?.isInProgress = false
            case .some:
                Logger.debug("<Firebase> - User created on Firebase.")
                
                Task {
                    do {
                        try await self?.authManager.grantAuth()
                        let membershipNumber = LoyaltyUtilities.randomString(of: 8)
                        let enrolledMember = try await self?.loyaltyAPIManager.postEnrollment(membershipNumber: membershipNumber,
                                                                                              firstName: firstName,
                                                                                              lastName: lastName,
                                                                                              email: userEmail,
                                                                                              phone: mobileNumber,
                                                                                              emailNotification: joinEmailList)
                        guard let enrolled = enrolledMember else {
                            self?.userErrorMessage = ("Loyalty member enrollment failed.", .signUp)

                            // Member Enrollment failed, then delete User from Firebase
                            let user = Auth.auth().currentUser

                            user?.delete { error in
                              if let error = error {
                                  Logger.error("<Firebase> - Could not delete current user. \(error)")
                              } else {
                                  Logger.debug("<Firebase> - User was deleted.")
                              }
                            }
                            self?.isInProgress = false
                            return
                        }
                        
                        let enrollmentDetails = EnrollmentDetails(loyaltyProgramMemberId: enrolled.loyaltyProgramMemberId,
                                                                  loyaltyProgramName: enrolled.loyaltyProgramName,
                                                                  membershipNumber: enrolled.membershipNumber)
                        
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
                        Logger.debug("<Firestore> - Member info saved.")
                        
                        self?.userState = .signedUp
                        self?.isInProgress = false
                    } catch {
                        self?.userErrorMessage = (error.localizedDescription, .signUp)

                        // Member Enrollment failed, then delete User from Firebase
                        let user = Auth.auth().currentUser

                        user?.delete { error in
                          if let error = error {
                              Logger.error("<Firebase> - Could not delete current user. \(error)")
                          } else {
                              Logger.debug("<Firebase> - User was deleted.")
                          }
                        }
                        self?.isInProgress = false
                        return
                    }

                }

            }
            
        }
         */
    }
    
	func signInUser(userEmail: String, userPassword: String) async throws {
		isInProgress = true
		email = userEmail
		do {
            let app = AppSettings.shared.getConnectedApp()
			let auth = try await ForceAuthManager.shared.authenticate(
				communityURL: app.communityURL,
				consumerKey: app.consumerKey,
				callbackURL: app.callbackURL,
				username: userEmail,
				password: userPassword)
			ForceAuthManager.shared.auth = auth
			Logger.debug("Successfully Granted Access Token. Allow user to login.")
			
			// Retrieve member data from local disk
			let member = LocalFileManager.instance.getData(type: CommunityMemberModel.self, id: userEmail)
			
			if let member = member {
				self.member = member
			} else {
				// Cannot get the member info from local, then call getCommunityMemberProfile
				let authManager = ForceAuthManager.shared
				let loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
														  loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                                          instanceURL: AppSettings.shared.getInstanceURL(),
                                                          forceClient: ForceClient(auth: authManager))
				let profile = try await loyaltyAPIManager.getCommunityMemberProfile()
				
				Logger.debug("\(profile)")
				
				let member = CommunityMemberModel(firstName: profile.associatedContact.firstName,
												  lastName: profile.associatedContact.lastName,
												  email: userEmail,
												  loyaltyProgramMemberId: profile.loyaltyProgramMemberID,
												  loyaltyProgramName: profile.loyaltyProgramName,
												  membershipNumber: profile.membershipNumber)
				// Save member to local disk
				LocalFileManager.instance.saveData(item: member, id: userEmail)
                
                self.member = member
			}
			
			self.isInProgress = false
			self.userState = .signedIn
			
        } catch CommonError.unknownException {
            // if it's 500 error then we need enroll user to the loylty program
            self.isInProgress = false
            self.userState = .signedInButNotJoined
            
        } catch {
			// clear auth
			authManager.clearAuth()
			
			self.isInProgress = false
			self.userErrorMessage = (error.localizedDescription, .signIn)
		}
	}
    
    func joinProgram(emailNotification: Bool) {
        isInProgress = true
        Task {
            do {
                let forceClient = ForceClient(auth: authManager)
                let contactQuery = "SELECT FirstName, LastName, Phone FROM Contact WHERE Email = '\(email)'"
                let queryResult = try await forceClient.SOQL(type: Record.self, for: contactQuery)
                let contact = queryResult.records.first
                
                // Need to save contact info for enrollment
                let firstName = contact?.string(forField: "FirstName") ?? ""
                let lastName = contact?.string(forField: "LastName") ?? ""
                let phone = contact?.string(forField: "Phone") ?? ""
                
                Logger.debug("First Name: \(firstName) | Last Name: \(lastName) | Phone: \(phone)")
                
                let membershipNumber = LoyaltyUtilities.randomString(of: 8)
                let enrolledMember = try await loyaltyAPIManager.postEnrollment(membershipNumber: membershipNumber,
                                                                                firstName: firstName,
                                                                                lastName: lastName,
                                                                                email: email,
                                                                                phone: phone,
                                                                                emailNotification: emailNotification)

                let member = CommunityMemberModel(firstName: firstName,
                                                  lastName: lastName,
                                                  email: email,
                                                  loyaltyProgramMemberId: enrolledMember.loyaltyProgramMemberId,
                                                  loyaltyProgramName: enrolledMember.loyaltyProgramName,
                                                  membershipNumber: membershipNumber)
                // Save member to local disk
                LocalFileManager.instance.saveData(item: member, id: email)

                self.member = member
                
                self.isInProgress = false
                self.userState = .signedIn
                
            } catch {
                Logger.error(error.localizedDescription)
                
                // clear auth
                authManager.clearAuth()
                
                self.isInProgress = false
                self.userErrorMessage = (error.localizedDescription, .enrollUser)
            }
        }
    }
    
    func exitJoinProgram() {
        authManager.clearAuth()
    }
    
    func signOutUser() {
        isInProgress = true
        
        ForceAuthManager.shared.clearAuth()
        userState = .signedOut
        isInProgress = false
        member = nil
        
        // delete all cached data
        LocalFileManager.instance.removeAllAppData()
    }
    
    func requestResetPassword(userEmail: String) {
        
        isInProgress = true
        
        // TODO: redo requestResetPassword since Firebase is removed
        /*
        Auth.auth().sendPasswordReset(withEmail: userEmail) { [weak self] error in
            
            if let error = error {
                self?.isInProgress = false
                self?.userErrorMessage = (error.localizedDescription, .resetPassword)
                return
            }
            
            self?.userState = .resetPasswordRequested
            self?.isInProgress = false
            
        }
         */
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
            let request = try ForceRequest.create(url: url, method: "POST", body: bodyJsonData)
            let result = try await NetworkManager.shared.fetch(type: PasswordResetModel.self, request: request)
            email = result.email
            userState = .newPasswordSet
        } catch {
            userErrorMessage = (error.localizedDescription, .createNewPassword)
        }
    }
    
}
