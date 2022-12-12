//
//  CreateNewPasswordView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @Binding var showCreateNewPassword: Bool
    
    @State private var password = ""
    @State private var passwordConfirmation = ""
    
    var body: some View {
        ZStack {
            Color.white
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width > 0 {
                            withAnimation {
                                showCreateNewPassword.toggle()
                            }
                        }
                    })
                )
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
                    Text("New Password")
                        .font(.congratsTitle)
                    Spacer()
                }
            
                HStack {
                    Text("Enter a password that's not the same as your previous passwords.")
                        .font(.congratsText)
                        .foregroundColor(Color.theme.superLightText)
                        .lineSpacing(5)
                        .padding(.bottom, 50)
                    Spacer()
                }
                
                
                Group {
                    HStack {
                        Text("Password")
                            .font(.textFieldLabel)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    RevealableSecureField("Enter password...", text: $password)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("Confirm Password")
                            .font(.textFieldLabel)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    RevealableSecureField("Enter your password again...", text: $passwordConfirmation)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: passwordConfirmation != password ? 2 : 0)
                            .padding([.leading, .trailing])
                        )
                }
                
                if !viewModel.userErrorMessage.0.isEmpty {
                    Text("Failed creating new password: \(viewModel.userErrorMessage.0)")
                        .foregroundColor(.red)
                }
                
                Button("Confirm") {
                    Task {
                        await viewModel.resetPassword(newPassword: password)
                    }
                    UIApplication.shared.dismissKeyboard()
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                .onReceive(viewModel.$userState) { state in
                    if state == UserState.newPasswordSet {
                        print("Password reset for \(viewModel.email) is successful.")
                        viewModel.signInUser(userEmail: viewModel.email, userPassword: password)
                    }
                } //TODO: redirect to other page: home or onboarding? Need confirmation
                .onReceive(viewModel.$userState) { state in
                    if state == UserState.signedIn  {
                        viewModel.isInProgress = false
                        appViewRouter.signedIn = true
                        appViewRouter.currentPage = .navTabsPage()
                    }
                }
                
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .padding()
            
            if viewModel.isInProgress {
                ProgressView()
            }
            
        }
        .zIndex(2.0)
        .ignoresSafeArea()
    }
    
    var disableForm: Bool {
        if password.isEmpty ||
            passwordConfirmation.isEmpty ||
            viewModel.isInProgress {
            return true
        }
        return false
    }
}

struct CreateNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPasswordView(showCreateNewPassword: .constant(false))
            .environmentObject(AppRootViewModel())
    }
}
