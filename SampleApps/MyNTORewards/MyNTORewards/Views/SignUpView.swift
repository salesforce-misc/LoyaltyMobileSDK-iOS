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
            SheetHeader(title: "Join")
            ScrollView {
                ZStack {
                    VStack {
                        VStack(spacing: 15) {
                            SignUpCredentialFields(
                                firstName: $firstName,
                                lastName: $lastName,
                                mobileNumber: $mobileNumber,
                                email: $email,
                                password: $password,
                                passwordConfirmation: $passwordConfirmation,
                                acceptTerms: $acceptTerms,
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
                            .disabled(disableForm)
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
    @Binding var acceptTerms: Bool
    @Binding var joinEmailList: Bool
    @Binding var showTermsPopover: Bool
    
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
                        TermsAndConditions()
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

struct TermsAndConditions: View {
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Terms and Conditions")
            ScrollView {
                VStack {
                    
                    // swiftlint:disable line_length
                    Text("""
                    1. Introduction
                    
                    1.1. These Terms & Conditions ("Terms") govern the MyNTORewards Loyalty Program ("Program") offered by MyNTO Ltd. ("MyNTO," "we," "us," or "our"). By participating in the Program, you ("Member," "you," or "your") agree to be bound by these Terms, as well as our Privacy Policy, incorporated herein by reference.

                    1.2. We reserve the right, at our sole discretion, to modify or update these Terms at any time without prior notice. Your continued participation in the Program after any such changes constitutes your acceptance of the new Terms.

                    2. Membership Eligibility and Enrollment
                    
                    2.1. The Program is open to individuals who are 18 years of age or older and have a valid email address.

                    2.2. To enroll in the Program, you must provide your full name, email address, and any other required information.

                    2.3. There is no cost to join the Program.

                    3. Earning MyNTORewards Points
                    
                    3.1. Members can earn MyNTORewards Points ("Points") by making qualifying purchases at participating MyNTO locations or through our website and mobile app.

                    3.2. Points will be credited to your account within 24 hours of your qualifying purchase.

                    3.3. The number of Points earned per qualifying purchase may vary and will be determined by us at our sole discretion.

                    3.4. Points are non-transferable, have no cash value, and may not be combined with any other offers, discounts, or promotions.

                    4. Redeeming Points
                    
                    4.1. Members can redeem Points for rewards ("Rewards") available through the Program.

                    4.2. The number of Points required to redeem a Reward may vary and will be determined by us at our sole discretion.

                    4.3. Rewards are subject to availability and may be substituted or discontinued at any time without prior notice.

                    4.4. Rewards cannot be exchanged, returned, or refunded for Points, cash, or any other form of credit.

                    5. Account Management
                    
                    5.1. You are responsible for maintaining the confidentiality of your account information, including your password.

                    5.2. Any unauthorized use of your account or any other breach of security must be reported to us immediately.

                    5.3. We reserve the right to suspend or terminate your account and participation in the Program if we determine, at our sole discretion, that you have violated these Terms.

                    6. Expiration and Termination
                    
                    6.1. Points will expire 48 months from the date they were earned.

                    6.2. We reserve the right to terminate the Program or your participation in the Program at any time, for any reason, without prior notice.

                    7. Limitation of Liability
                    
                    7.1. We are not responsible for any damages or losses arising from your participation in the Program, including, but not limited to, any errors, delays, or failures in the issuance, redemption, or use of Points or Rewards.

                    8. Governing Law
                    
                    8.1. These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which MyNTO is registered, without regard to its conflict of law provisions.

                    9. Contact Us
                    
                    9.1. If you have any questions or concerns about the Program or these Terms, please contact us at support@mynstorewards.com.
                    
                    
                    """)
                    .padding()
                    // swiftlint:enable line_length
            }
            
            }
        }
        
    }
}
