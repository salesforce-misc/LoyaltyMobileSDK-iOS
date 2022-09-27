//
//  SignInView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    @Environment(\.dismiss) private var dismiss
    
    @State var email = ""
    @State var password = ""
    
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    
    @Binding var signUpPresented: Bool
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            VStack {
                SheetHeader(title: "Sign In")
                VStack(spacing: 15) {
                    SignInCredentialFields(email: $email, password: $password)
                    Button(action: {
                        signInUser(userEmail: email, userPassword: password)
                    }) {
                        Text("Sign In")
                    }
                    .buttonStyle(DarkLongButton())
                    .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
                    if signInProcessing {
                        ProgressView()
                    }
                    if !signInErrorMessage.isEmpty {
                        Text("Failed creating account: \(signInErrorMessage)")
                            .foregroundColor(.red)
                    }
                    HStack {
                        Text("Not a member?")
                        Button(action: {
                            dismiss()
                            signUpPresented = true
                            appViewRouter.currentPage = .onboardingPage
                        }) {
                            Text("Join Now")
                                .font(.buttonText)
                        }
                        .presentationDetents([.height(405)])
                    }
                }
                .padding()
                Spacer()
            }
            
        } else {
            HalfSheet {
                VStack {
                    SheetHeader(title: "Sign In")
                    VStack(spacing: 15) {
                        SignInCredentialFields(email: $email, password: $password)
                        Button(action: {
                            signInUser(userEmail: email, userPassword: password)
                        }) {
                            Text("Sign In")
                        }
                        .buttonStyle(DarkLongButton())
                        .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
                        if signInProcessing {
                            ProgressView()
                        }
                        if !signInErrorMessage.isEmpty {
                            Text("Failed creating account: \(signInErrorMessage)")
                                .foregroundColor(.red)
                        }
                        HStack {
                            Text("Not a member?")
                            Button(action: {
                                dismiss()
                                signUpPresented = true
                                appViewRouter.currentPage = .onboardingPage
                            }) {
                                Text("Join Now")
                                    .font(.buttonText)
                            }

                        }
                    }
                    .padding()
                    Spacer()
                }
                
            }
        }


    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                signInProcessing = false
            case .some(_):
                print("User signed in")
                signInProcessing = false
                appViewRouter.currentPage = .homePage
                appViewRouter.signedIn = true
                Task{
                    do {
                        try await ForceAuthManager.shared.grantAuth()
                    }catch {
                        print("failed to grantAuth")
                    }
                }
            }
            
        }

    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(signUpPresented: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group {
            TextField("Email", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
            RevealableSecureField("Password", text: $password)
        }
    }
}

