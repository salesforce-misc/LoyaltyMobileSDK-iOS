//
//  ResetPasswordView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @Binding var showResetPassword: Bool
    @Binding var signInPresented: Bool
    
    @State private var email = ""
    @State private var showCheckEmail = false
    
    var body: some View {
        ZStack {
            Color.white
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width > 0 {
                            withAnimation {
                                showResetPassword.toggle()
                            }
                            signInPresented.toggle()
                            viewModel.userErrorMessage = ("", .noerror)
                        }
                    })
                )
            VStack(spacing: 15) {
                HStack {
                    Button {
                        withAnimation {
                            showResetPassword.toggle()
                        }
                        signInPresented.toggle()
                        viewModel.userErrorMessage = ("", .noerror)
                        
                    } label: {
                        Image("ic-backarrow")
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                HStack {
                    Text("Reset password")
                        .font(.congratsTitle)
                    Spacer()
                }
                
                Text("Enter the email or member number associated with your account and we’ll send an email with instructions to reset your password.")
                    .font(.congratsText)
                    .foregroundColor(Color.theme.superLightText)
                    .lineSpacing(5)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RegularTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                if !viewModel.userErrorMessage.0.isEmpty {
                    Text("Failed resetting password: \(viewModel.userErrorMessage.0)")
                        .foregroundColor(.red)
                }
                
                Button("Send Instructions") {
                    viewModel.requestResetPassword(userEmail: email)
                    UIApplication.shared.dismissKeyboard()
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                .onReceive(viewModel.$userState) { state in
                    if state == UserState.resetpassword {
                        self.email = ""
                        withAnimation {
                            showCheckEmail.toggle()
                        }
                    }
                }
                
                Spacer()

            }
            .padding([.leading, .trailing], 10)
            .padding()
            
            if viewModel.isInProgress {
                ProgressView()
            }
            
            if showCheckEmail {
                CheckYourEmailView(showCheckEmail: $showCheckEmail, showResetPassowrd: $showResetPassword)
                    .transition(.move(edge: .bottom))
            }
        }
        .zIndex(2.0)
        .ignoresSafeArea()

    }
    
    var disableForm: Bool {
        if email.isEmpty ||
            viewModel.isInProgress {
            return true
        }
        return false
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(showResetPassword: .constant(true), signInPresented: .constant(false))
            .environmentObject(AppRootViewModel())
    }
}
