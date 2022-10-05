//
//  CreateNewPasswordView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    @Binding var showCreateNewPassword: Bool
    
    @State private var password = ""
    @State private var passwordConfirmation = ""
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 15) {
                HStack {
                    Button {
                        withAnimation {
                            showCreateNewPassword.toggle()
                        }
                        
                    } label: {
                        Image("ic-backarrow")
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                HStack {
                    Text("Create New Password")
                        .font(.congratsTitle)
                    Spacer()
                }
            
                Text("Your new password must be different from previous used passwords.")
                    .font(.congratsText)
                    .foregroundColor(Color.theme.superLightText)
                    .lineSpacing(5)
                    .padding(.bottom, 50)
                
                Group {
                    HStack {
                        Text("Password")
                            .font(.textFieldLabel)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    RevealableSecureField("Enter password", text: $password)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("Confirm Password")
                            .font(.textFieldLabel)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    RevealableSecureField("Re-enter your password", text: $passwordConfirmation)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: passwordConfirmation != password ? 2 : 0)
                            .padding([.leading, .trailing])
                        )
                }
                
                Button("Reset Password") {
                    Task {
                        await viewModel.resetPassword(newPassword: password, oobCode: viewModel.oobCode, apiKey: viewModel.apiKey)
                    }
                    UIApplication.shared.dismissKeyboard()
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                .onReceive(viewModel.$createNewPassSuccessful) { succesful in
                    if succesful {
                        print("Password reset for \(viewModel.email) is successful.")
                        viewModel.signInUser(userEmail: viewModel.email, userPassword: password)
                        
//                        //TODO: redirect to other page: home or onboarding?
//                        appViewRouter.signedIn = true
//                        appViewRouter.currentPage = .navTabsPage(selectedTab: .home)
                        
                    }
                }
                .onReceive(viewModel.$signInSuccesful) { successful in
                    if successful {
                        viewModel.createNewPassProgressing = false
                        appViewRouter.signedIn = true
                        appViewRouter.currentPage = .navTabsPage(selectedTab: .home)
                    }
                }
                
                if viewModel.createNewPassProgressing {
                    ProgressView()
                }
                
                if !viewModel.createNewPassErrorMessage.isEmpty {
                    Text("Failed creating new password: \(viewModel.requestResetPassErrorMessage)")
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .padding()
            
        }
        .zIndex(2.0)
        .ignoresSafeArea()
    }
    
    var disableForm: Bool {
        if password.isEmpty ||
            passwordConfirmation.isEmpty ||
            viewModel.createNewPassProgressing {
            return true
        }
        return false
    }
}

struct CreateNewPasswordView_Previews: PreviewProvider {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    static var previews: some View {
        CreateNewPasswordView(showCreateNewPassword: .constant(false))
            .environmentObject(OnboardingViewModel())
    }
}
