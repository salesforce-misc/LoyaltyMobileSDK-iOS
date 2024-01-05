//
//  SignUpView.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobileNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var acceptTerms = false
    @State private var joinEmailList = false
    @State private var showTermsPopover = false
    
    @Binding var signInPresented: Bool
    @Binding var signUpPresented: Bool
    
    var body: some View {
        VStack {
            SheetHeader(title: "Join") {
                signUpPresented = false
                if viewModel.userState == .signedInButNotJoined {
                    viewModel.exitJoinProgram()
                }
                viewModel.userState = .none
            }
            ScrollView {
                ZStack {
                    VStack {
                        VStack(spacing: 15) {
                            
                            if viewModel.userState == .none {
                                SignUpCredentialFields(
                                    firstName: $firstName,
                                    lastName: $lastName,
                                    mobileNumber: $mobileNumber,
                                    email: $email,
                                    password: $password,
                                    passwordConfirmation: $passwordConfirmation)
                                
                                TermsFields(acceptTerms: $acceptTerms,
                                            joinEmailList: $joinEmailList,
                                            showTermsPopover: $showTermsPopover)
                                
                                if !viewModel.userErrorMessage.0.isEmpty {
                                    Text("Failed creating account: \(viewModel.userErrorMessage.0)")
                                        .foregroundColor(.red)
                                }
                                
                                Button(action: {
                                    viewModel.signUpUser(userEmail: email,
                                                         userPassword: password,
                                                         firstName: firstName,
                                                         lastName: lastName,
                                                         mobileNumber: mobileNumber,
                                                         joinEmailList: joinEmailList)
                                    UIApplication.shared.dismissKeyboard()
                                }) {
                                    Text("Join")
                                }
                                .buttonStyle(DarkLongButton())
                                .disabled((disableForm))
                                .opacity(disableForm ? 0.5 : 1)
                                
                                HStack {
                                    Text("Already a Member?")
                                        .accessibilityIdentifier(AppAccessibilty.Signup.alreadyMemberLabel)
                                    Button(action: {
                                        signUpPresented = false
                                        signInPresented = true
                                        viewModel.userErrorMessage = ("", ErrorType.noError)
                                    }) {
                                        Text("Log In")
                                            .font(.buttonText)
                                    }
                                    .accessibilityIdentifier(AppAccessibilty.Signup.loginButton)
                                }
                            } else if viewModel.userState == .signedInButNotJoined {
                                // swiftlint:disable line_length
                                Text("Currently you are not in our rewards program. You are welcome to join. We have made easy for you by simply clicking Join button below.")
                                    .font(.congratsText)
                                    .lineSpacing(5)
                                    .multilineTextAlignment(.leading)
                                    .padding(12)
                                // swiftlint:enable line_length
                                
                                Spacer()
                                
                                TermsFields(acceptTerms: $acceptTerms,
                                            joinEmailList: $joinEmailList,
                                            showTermsPopover: $showTermsPopover)
                                
                                Button(action: {
                                    viewModel.joinProgram(emailNotification: joinEmailList)
                                    UIApplication.shared.dismissKeyboard()
                                }) {
                                    Text("Join")
                                }
                                .buttonStyle(DarkLongButton())
                                .disabled((!acceptTerms || viewModel.isInProgress))
                                .opacity((!acceptTerms || viewModel.isInProgress) ? 0.5 : 1)
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
        if firstName.isEmpty ||
            lastName.isEmpty ||
            mobileNumber.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            passwordConfirmation.isEmpty ||
            password != passwordConfirmation ||
            !acceptTerms ||
            viewModel.isInProgress {
            return true
        }
        return false
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signInPresented: .constant(false), signUpPresented: .constant(false))
            .environmentObject(AppRootViewModel())
    }
}

struct SignUpCredentialFields: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var mobileNumber: String
    @Binding var email: String
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
    @FocusState private var passwordConfirmationIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    
    var body: some View {
        Group {
            LoyaltyTextField(textFieldType: .firstName, inputText: $firstName)
            LoyaltyTextField(textFieldType: .lastName, inputText: $lastName)
            LoyaltyTextField(textFieldType: .email, inputText: $email)
            LoyaltyTextField(textFieldType: .phoneNumber, inputText: $mobileNumber)
            
            RevealableSecureField("Password", text: $password)
                .accessibility(identifier: AppAccessibilty.Signup.password)
            .focused($passwordIsFocused)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color.red,
                        lineWidth: (
                            !SignUpTextFieldType.password.validate(text: password) && passwordIsFocused
                        ) ? 2 : 0
                    )
                    .padding(.horizontal)
                )
            if !SignUpTextFieldType.password.validate(text: password) && passwordIsFocused {
                Text(SignUpTextFieldType.password.errorMessage)
                    .accessibility(identifier: SignUpTextFieldType.password.accessibilityIdentifier + "error")
                    .font(.labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.red)
                    .padding(.leading)
            }
            
            RevealableSecureField("Confirm password", text: $passwordConfirmation)
            .focused($passwordConfirmationIsFocused)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color.red,
                        lineWidth: (
                            passwordConfirmation != password &&
                            (passwordConfirmationIsFocused || passwordConfirmation.isEmpty)
                        ) ? 2 : 0)
                    .padding(.horizontal)
                )
                .accessibility(identifier: AppAccessibilty.Signup.confirmPassword)
            if passwordConfirmation != password && (passwordConfirmationIsFocused || passwordConfirmation.isEmpty) {
                Text(SignUpTextFieldType.confirmPassword.errorMessage)
                    .font(.labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.red)
                    .padding(.leading)
                    .accessibility(identifier: SignUpTextFieldType.confirmPassword.accessibilityIdentifier + "error")
                
            }
            
        }
    }
}

struct TermsFields: View {
    
    @Binding var acceptTerms: Bool
    @Binding var joinEmailList: Bool
    @Binding var showTermsPopover: Bool
    
    var body: some View {
        Group {
            Toggle(isOn: $acceptTerms) {
                HStack(spacing: 0) {
                    Text("I agree to the ")
                        .accessibility(identifier: AppAccessibilty.Signup.agreeLabel)
                    Button(action: {
                        showTermsPopover.toggle()
                    }, label: {
                        Text("terms and conditions")
                            .foregroundColor(Color.theme.accent)
                    })
                    .accessibility(identifier: AppAccessibilty.Signup.agreeButton)
                    .popover(isPresented: $showTermsPopover) {
                        TermsAndConditionsView()
                    }
                    
                }
            }
            .accessibility(identifier: AppAccessibilty.Signup.agreeCheckbox)
            .toggleStyle(CheckboxStyle())
            .padding(.horizontal)
            Toggle(isOn: $joinEmailList) {
                Text("Add me to the loyalty program's mailing list")
                    .accessibility(identifier: AppAccessibilty.Signup.mailListLabel)
            }
            .toggleStyle(CheckboxStyle())
            .padding(.horizontal)
            .accessibility(identifier: AppAccessibilty.Signup.mailListCheckbox)
            
        }
    }
}
