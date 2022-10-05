//
//  SignUpView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    //@State private var mobileNumber = ""
    @State private var email = ""
    //@State private var username = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    
    @Binding var signInPresented: Bool
    @Binding var signUpPresented: Bool
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Join")
            
            VStack(spacing: 15) {
                SignUpCredentialFields(
                    firstName: $firstName,
                    lastName: $lastName,
                    email: $email,
                    password: $password,
                    passwordConfirmation: $passwordConfirmation)
                
                Button(action: {
                    viewModel.signUpUser(userEmail: email, userPassword: password, firstName: firstName, lastName: lastName)
                }) {
                    Text("Join")
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                .onReceive(viewModel.$signUpSuccesful) { successful in
                    if successful {
                        signUpPresented = false
                        appViewRouter.currentPage = .onboardingPage
                    }
                }
                
                if viewModel.signUpProcessing {
                    ProgressView()
                }
                
                if !viewModel.signUpErrorMessage.isEmpty {
                    Text("Failed creating account: \(viewModel.signUpErrorMessage)")
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("Already a member?")
                    Button(action: {
                        signUpPresented = false
                        signInPresented = true
                        appViewRouter.currentPage = .onboardingPage
                        
                    }) {
                        Text("Sign In")
                            .font(.buttonText)
                    }
                    //.presentationDetents([.height(746)])
                    
                }
            }
            .padding()
            Spacer()
        }

    }
    
    var disableForm: Bool {
        if firstName.isEmpty ||
            lastName.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            passwordConfirmation.isEmpty ||
            password != passwordConfirmation ||
            viewModel.signUpProcessing {
            return true
        }
        return false
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    static var previews: some View {
        SignUpView(signInPresented: .constant(false), signUpPresented: .constant(false))
            .environmentObject(OnboardingViewModel())
    }
}

struct SignUpCredentialFields: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    //@Binding var mobileNumber: String
    @Binding var email: String
    //@Binding var username: String
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
    var body: some View {
        Group {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RegularTextFieldStyle())
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RegularTextFieldStyle())
            TextField("Email Address", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.emailAddress)
            RevealableSecureField("Password", text: $password)
            RevealableSecureField("Confirm Password", text: $passwordConfirmation)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: passwordConfirmation != password ? 2 : 0)
                    .padding([.leading, .trailing])
                )
            
        }
    }
}

