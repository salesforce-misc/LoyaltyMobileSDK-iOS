//
//  SignInView.swift
//  LoyaltyStarter
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
            SheetHeader(title: "Sign In")
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
                                Text("Forgot Password?")
                                    .foregroundColor(Color.theme.accent)
                                    .font(.regularText)
                                    .onTapGesture {
                                        withAnimation {
                                            signUpPresented = false
                                            signInPresented = false
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
                                Text("Sign In")
                            }
                            .buttonStyle(DarkLongButton())
                            .disabled(disableForm)
                            .opacity(disableForm ? 0.5 : 1)
                            
                            HStack {
                                Text("Not a member?")
                                Button(action: {
                                    signInPresented = false
                                    signUpPresented = true
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
            TextField("Email", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.emailAddress)
            RevealableSecureField("Password", text: $password)
        }
    }
}

