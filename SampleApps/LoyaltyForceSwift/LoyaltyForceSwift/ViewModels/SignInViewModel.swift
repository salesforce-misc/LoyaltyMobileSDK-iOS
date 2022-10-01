//
//  SignInViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/29/22.
//

import Foundation
import Firebase

@MainActor
class SignInViewModel: ObservableObject {
    
    @Published var signInPresented = false
    @Published var signInProcessing = false
    @Published var signInErrorMessage = ""
    
    var appViewRouter: AppViewRouter
    
    init(appViewRouter: AppViewRouter) {
        self.appViewRouter = appViewRouter
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
                        self?.signInPresented = false
                        self?.appViewRouter.signedIn = true
                        self?.appViewRouter.currentPage = .homePage
                    } catch {
                        self?.signInErrorMessage = error.localizedDescription
                    }
                }
            }
            
        }

    }
}
