//
//  SignInView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var signInVM: SignInViewModel
    @EnvironmentObject private var signUpVM: SignUpViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Sign In")
            VStack {
                SignInCredentialFields(email: $email, password: $password)
                Button(action: {
                    signInVM.signInUser(userEmail: email, userPassword: password)
                }) {
                    Text("Sign In")
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                
                if signInVM.signInProcessing {
                    ProgressView()
                }
                
                if !signInVM.signInErrorMessage.isEmpty {
                    Text("Failed creating account: \(signInVM.signInErrorMessage)")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("Not a member?")
                    Button(action: {
                        signInVM.signInPresented = false
                        signUpVM.signUpPresented = true
                        appViewRouter.currentPage = .onboardingPage
                        print("Not a member? Join Now clicked: signUpVM.signUpPresented=\(signUpVM.signUpPresented)")
                        print("Not a member? Join Now clicked: signInVM.signInPresented=\(signInVM.signInPresented)")
                    }) {
                        Text("Join Now")
                            .font(.buttonText)
                    }
                    //.presentationDetents([.height(405)])
                }
            }
            .padding()
            Spacer()
        }
        
    }
    
    var disableForm: Bool {
        if email.isEmpty ||
            password.isEmpty ||
            signInVM.signInProcessing {
            return true
        }
        return false
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
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
                .keyboardType(.emailAddress)
            RevealableSecureField("Password", text: $password)
        }
    }
}

