//
//  SignInView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Sign In")
            VStack {
                SignInCredentialFields(email: $email, password: $password)
                Button(action: {
                    viewModel.signInUser(userEmail: email, userPassword: password)
                }) {
                    Text("Sign In")
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                
                if viewModel.signInProcessing {
                    ProgressView()
                }
                
                if !viewModel.signInErrorMessage.isEmpty {
                    Text("Failed signing in: \(viewModel.signInErrorMessage)")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("Not a member?")
                    Button(action: {
                        viewModel.signInPresented = false
                        viewModel.signUpPresented = true
                        appViewRouter.currentPage = .onboardingPage
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
            viewModel.signInProcessing {
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

