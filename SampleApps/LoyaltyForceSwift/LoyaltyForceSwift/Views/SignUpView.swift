//
//  SignUpView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var firstName = ""
    @State var lastName = ""
    //@State var mobileNumber = ""
    @State var email = ""
    //@State var username = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    
    @State var signUpProcessing = false
    
    @Binding var signInPresented: Bool
    @Binding var signUpPresented: Bool
    
    @State var signUpSuccessful = false
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
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
                    .sheet(isPresented: $viewModel.signUpSuccesful) {
                        CongratsView(email: email)
                            .interactiveDismissDisabled()
                            .onDisappear {
                                signUpPresented = false
                                appViewRouter.signedIn = true
                                appViewRouter.currentPage = .homePage
                            }
                    }
                    //.presentationDetents([.height(746)])
                    
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
                            dismiss()
                            signInPresented = true
                            appViewRouter.currentPage = .onboardingPage
                        }) {
                            Text("Sign In")
                                .font(.buttonText)
                        }
                        .presentationDetents([.height(746)])

                    }
                }
                .padding()
                Spacer()
            }
            
        } else {
            HalfSheet {
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
                        .sheet(isPresented: $viewModel.signUpSuccesful) {
                            CongratsView(email: email)
                                .interactiveDismissDisabled()
                                .onDisappear {
                                    signUpPresented = false
                                    appViewRouter.signedIn = true
                                    appViewRouter.currentPage = .homePage
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
                                dismiss()
                                signInPresented = true
                                appViewRouter.currentPage = .onboardingPage
                            }) {
                                Text("Sign In")
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
    
    var disableForm: Bool {
        firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty ||
        password != passwordConfirmation
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signInPresented: .constant(false), signUpPresented: .constant(false))
            .previewLayout(.sizeThatFits)
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

