//
//  EnrollmentViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

import Foundation
import Firebase

@MainActor
class OnboardingViewModel: ObservableObject {
    
    @Published var enrolledMember: EnrollmentOutputModel?
    
    // SignUpView
    @Published var signUpProcessing = false
    @Published var signUpErrorMessage = ""
    @Published var signUpSuccesful = false
    
    // CongratsView
    @Published var email = ""
    
    // SignInView
    @Published var signInProcessing = false
    @Published var signInErrorMessage = ""
    @Published var signInSuccesful = false
    
    // ResetPasswordView
    @Published var requestResetPassProcessing = false
    @Published var requestResetPassErrorMessage = ""
    @Published var resetPasswordEmailSent = false
    
    // CreateNewPasswordView
    @Published var createNewPassProgressing = false
    @Published var createNewPassErrorMessage = ""
    @Published var createNewPassSuccessful = false
    
    // SignOutView
    @Published var signOutProcessing = false
    @Published var signOutSuccessful = false
    
    // Password Reset
    @Published var oobCode = ""
    @Published var apiKey = ""
    
    func signUpUser(userEmail: String, userPassword: String, firstName: String, lastName: String) {
        
        signUpProcessing = true
        email = userEmail
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            
            if let error = error {
                self?.signUpProcessing = false
                self?.signUpErrorMessage = error.localizedDescription
                return
            }

            switch authResult {
            case .none:
                print("<Firebase> - Could not create account.")
                self?.signUpProcessing = false
            case .some(_):
                print("<Firebase> - User created on Firebase.")
                
                Task {
                    do {
                        try await ForceAuthManager.shared.grantAuth()
                        self?.enrolledMember = try await LoyaltyAPIManager.shared.postEnrollment(firstName: firstName, lastName: lastName, email: userEmail)
                        if let member = self?.enrolledMember {
                            print(member)
                        }
                        self?.signUpSuccesful = true
                        self?.signOutSuccessful = false
                        self?.signUpProcessing = false
                    } catch {
                        self?.signUpErrorMessage = error.localizedDescription
                        
                        // Member Enrollment failed, then delete User from Firebase
                        let user = Auth.auth().currentUser

                        user?.delete { error in
                          if let error = error {
                              print("<Firebase> - Could not delete current user. \(error)")
                          } else {
                              print("<Firebase - User was deleted.")
                          }
                        }
                        self?.signUpProcessing = false
                        return
                    }

                }
                
            }
            
        }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            
            if let error = error {
                self?.signInProcessing = false
                self?.signInErrorMessage = error.localizedDescription
                return
            }
            
            switch authResult {
            case .none:
                print("<Firebase> - Could not sign in user.")
                self?.signInProcessing = false
            case .some(_):
                print("<Firebase> - User signed in")
                Task{
                    do {
                        try await ForceAuthManager.shared.grantAuth()
                        self?.signInProcessing = false
                        self?.signInSuccesful = true
                        self?.signOutSuccessful = false
                    } catch {
                        self?.signInErrorMessage = error.localizedDescription
                    }
                }
            }
            
        }

    }
    
    func signOutUser() {
        
        signOutProcessing = true
        
        do {
            try Auth.auth().signOut()
            ForceAuthManager.shared.clearAuth()
            signInSuccesful = false
            signOutSuccessful = true
            signOutProcessing = false
        } catch {
            print("<Firebase> - Error signing out: \(error.localizedDescription)")
            signOutProcessing = false
        }
    }
    
    func requestResetPassword(userEmail: String) {
        
        requestResetPassProcessing = true
        
        Auth.auth().sendPasswordReset(withEmail: userEmail) { [weak self] error in
            
            if let error = error {
                self?.requestResetPassProcessing = false
                self?.requestResetPassErrorMessage = error.localizedDescription
                return
            }
            
            self?.resetPasswordEmailSent = true
            self?.requestResetPassProcessing = false
            
        }
    }
    
    // Firebase REST API Endpoint: https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=[API_KEY]
    // Refrence: https://firebase.google.com/docs/reference/rest/auth#section-verify-password-reset-code
    func resetPassword(newPassword: String, oobCode: String, apiKey: String) async {
        
        createNewPassProgressing = true
        
        guard let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=\(apiKey)") else {
            createNewPassErrorMessage = URLError(.badURL).localizedDescription
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
            createNewPassSuccessful = true
        } catch {
            createNewPassErrorMessage = error.localizedDescription
        }
    }
    
}
