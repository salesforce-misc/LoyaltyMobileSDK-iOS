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
                                Button(action: {
                                    signUpPresented = false
                                    signInPresented = true
                                    viewModel.userErrorMessage = ("", ErrorType.noError)
                                }) {
                                    Text("Log In")
                                        .font(.buttonText)
                                }
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
    
    //@FocusState private var passwordConfirmationIsFocused: Bool
    
    var body: some View {
        Group {
            TextField("First name", text: $firstName)
                .textFieldStyle(RegularTextFieldStyle())
            TextField("Last name", text: $lastName)
                .textFieldStyle(RegularTextFieldStyle())
            TextField("Mobile number", text: $mobileNumber)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.phonePad)
            TextField("Email address", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.emailAddress)
            RevealableSecureField("Password", text: $password)
            RevealableSecureField("Confirm password", text: $passwordConfirmation)
                //.focused($passwordConfirmationIsFocused)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: passwordConfirmation != password ? 2 : 0)
                    .padding(.horizontal)
                )
            Toggle(isOn: $acceptTerms) {
                HStack(spacing: 0) {
                    Text("I agree to the ")
                    Button(action: {
                        showTermsPopover.toggle()
                    }, label: {
                        Text("terms and conditions")
                            .foregroundColor(Color.theme.accent)
                    })
                    .popover(isPresented: $showTermsPopover) {
                        TermsAndConditions()
                    }
                    
                }
            }
            .toggleStyle(CheckboxStyle())
            .padding(.horizontal)
            Toggle(isOn: $joinEmailList) {
                Text("Add me to the loyalty program's mailing list")
            }
            .toggleStyle(CheckboxStyle())
            .padding(.horizontal)

        }
    }
}

struct TermsAndConditions: View {
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Terms and Conditions")
            ScrollView {
                VStack {
                    Text("""
                    
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lorem dui, iaculis sit amet sodales sed, finibus mattis odio. Vivamus imperdiet venenatis sollicitudin. Duis aliquam dui nunc, nec interdum diam dapibus et. Praesent nec rutrum arcu. Cras vitae urna sed lectus auctor dapibus. Praesent nec velit a lacus euismod sagittis ac sit amet odio. Nulla posuere, lectus et egestas euismod, urna felis condimentum risus, ac dictum erat nisl ultrices turpis. Morbi ac maximus ligula, mattis pellentesque purus. Nullam dapibus sit amet est vel commodo. Curabitur non ex sit amet lectus auctor malesuada eu eu lacus. Phasellus volutpat, dui vitae consectetur volutpat, magna purus commodo nunc, quis faucibus libero justo auctor leo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce interdum urna ut lectus ullamcorper egestas. Quisque at dolor euismod, elementum ligula eget, lobortis ex. Cras sollicitudin feugiat pulvinar.

                    Vestibulum ultrices tortor sit amet erat aliquam cursus. Morbi convallis, dolor nec ullamcorper elementum, nisl elit fringilla tellus, vel sollicitudin orci quam ac felis. Praesent eget risus luctus, porttitor massa ut, consequat odio. Aliquam malesuada id est non efficitur. Nunc posuere ut lectus congue fermentum. Nam et purus in risus feugiat dignissim non eget ex. Fusce vitae dignissim metus, rhoncus rutrum ipsum. Mauris erat sapien, mattis eu leo eu, ullamcorper convallis ligula. Donec vel magna finibus lorem venenatis ullamcorper. Donec libero mauris, lobortis vitae mattis sit amet, feugiat quis nisi.

                    Sed pharetra ante sit amet odio blandit, vel pulvinar massa commodo. Morbi sit amet scelerisque augue. Nunc pretium eros sapien, quis dictum nibh tincidunt ut. Mauris facilisis elementum mauris, sit amet ornare lectus dictum quis. Nam dignissim scelerisque elit, et aliquam lorem blandit a. Donec semper ac nisi sit amet interdum. Vestibulum eleifend nisl sed nulla pulvinar rhoncus. Nullam malesuada faucibus tempor. Integer luctus at nulla vel gravida.

                    Donec feugiat, sem et tincidunt rutrum, arcu lectus commodo neque, ac pulvinar ex dui in sem. Cras ut erat eros. Donec eu orci at purus pellentesque dapibus vitae ac dolor. Nulla sed volutpat risus. Integer euismod nibh ac ex egestas tincidunt. Donec arcu urna, accumsan sit amet fringilla tempus, varius non augue. Quisque eu vestibulum augue. Mauris eget congue augue. Proin scelerisque sem congue diam hendrerit, eu tincidunt quam pellentesque. Duis in elit vel elit viverra aliquet vel id mauris. Praesent lobortis tellus quis odio volutpat, sit amet sollicitudin urna venenatis. Nulla facilisi.

                    Praesent tempus arcu ante, molestie vestibulum sem feugiat sit amet. Nullam quis commodo dui. Praesent imperdiet sem eget felis mattis, eu mattis est pharetra. Donec pharetra purus felis, eu dignissim ipsum lacinia ut. Sed commodo nisi non mollis euismod. Praesent pharetra pretium ultricies. Mauris viverra varius leo eu laoreet. Sed varius euismod est ac vulputate. Morbi eu faucibus leo. Suspendisse potenti. Sed pharetra pretium nisl, ac hendrerit libero sodales eget. Vivamus scelerisque pretium dui, non ultricies elit sodales non. Sed interdum interdum urna tincidunt ultricies. Etiam purus neque, pellentesque vel nisl vel, bibendum consequat lectus. Ut accumsan lorem at rhoncus volutpat. Aliquam nibh neque, ultricies lobortis leo in, accumsan tristique massa.
                    
                    """)
                    .padding()
            }
            
            }
        }
        
    }
}
