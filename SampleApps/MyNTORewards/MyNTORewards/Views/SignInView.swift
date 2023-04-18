//
//  SignInView.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @Binding var signInPresented: Bool
    @Binding var signUpPresented: Bool
    @Binding var showResetPassword: Bool
    
    
    var body: some View {
        VStack {
            SheetHeader(title: "Log In")
                .accessibilityIdentifier(AppAccessibilty.SignIn.loginHeader)
            ScrollView {
                ZStack {
                    VStack {
                        
                        VStack(spacing: 15) {
                            SignInCredentialFields(email: $email, password: $password)
                            
                            if !viewModel.userErrorMessage.0.isEmpty {
                                Text("Failed signing in: \(viewModel.userErrorMessage.0)")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            
                            // reset password
                            HStack {
                                Text("Forgot Your Password?")
                                    .accessibilityIdentifier(AppAccessibilty.SignIn.forgotPassword)
                                    .foregroundColor(Color.theme.accent)
                                    .font(.regularText)
                                    .onTapGesture {
                                        withAnimation {
                                            signUpPresented = false
                                            signInPresented = false
                                            viewModel.userErrorMessage = ("", ErrorType.noError)
                                            showResetPassword.toggle()
                                        }
                                        
                                    }
                                Spacer()
                            }
                            .padding([.top, .leading, .trailing])
                            
                            Button(action: {
                                viewModel.signInUser(userEmail: email, userPassword: password)
                                UIApplication.shared.dismissKeyboard()
                            }) {
                                Text("Log In")
                            }
                            .accessibilityIdentifier(AppAccessibilty.SignIn.loginButton)
                            .buttonStyle(DarkLongButton())
                            .disabled(disableForm)
                            .opacity(disableForm ? 0.5 : 1)
                            
                            HStack {
                                Text("Not a Member?")
                                    .accessibilityIdentifier(AppAccessibilty.SignIn.notAMember)
                                Button(action: {
                                    signInPresented = false
                                    signUpPresented = true
                                    viewModel.userErrorMessage = ("", ErrorType.noError)
                                }) {
                                    Text("Join Now")
                                        .font(.buttonText)
                                }
                                .accessibilityIdentifier(AppAccessibilty.SignIn.joinNow)
                                //.presentationDetents([.height(405)])
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    
                    if viewModel.isInProgress {
                        ProgressView()
                    }
                    
                }
            }
            
        }
        
        
    }
    
    var disableForm: Bool {
        if email.isEmpty ||
            password.isEmpty ||
            viewModel.isInProgress {
            return true
        }
        return false
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(signInPresented: .constant(false),
                   signUpPresented: .constant(false),
                   showResetPassword: .constant(false))
            .environmentObject(AppRootViewModel())
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group {
            TextField("Email address", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.emailAddress)
                .accessibilityIdentifier(AppAccessibilty.SignIn.userName)
            RevealableSecureField("Password", text: $password)
                .accessibilityIdentifier(AppAccessibilty.SignIn.password)
        }
    }
}

