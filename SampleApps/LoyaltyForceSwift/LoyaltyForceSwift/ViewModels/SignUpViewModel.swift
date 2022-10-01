//
//  EnrollmentViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

import Foundation
import Firebase

@MainActor
class SignUpViewModel: ObservableObject {
    
    @Published var enrolledMember: EnrollmentOutputModel?
    @Published var signUpPresented = false
    @Published var signUpProcessing = false
    @Published var signUpErrorMessage = ""
    @Published var signUpSuccesful = false
    @Published var email = ""
    
    var appViewRouter: AppViewRouter
    
    init(appViewRouter: AppViewRouter) {
        self.appViewRouter = appViewRouter
    }
    
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
                        self?.signUpPresented = false
                        self?.signUpSuccesful = true
                        self?.appViewRouter.currentPage = .onboardingPage
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
    
}
