//
//  ResetPasswordView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    @Binding var showResetPassword: Bool
    @Binding var signInPresented: Bool
    
    @State private var email = ""
    @State private var showCheckEmail = false
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 15) {
                HStack {
                    Button {
                        withAnimation {
                            showResetPassword.toggle()
                        }
                        signInPresented.toggle()
                        
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
                
                if viewModel.requestResetPassProcessing {
                    ProgressView()
                }
                
                if !viewModel.requestResetPassErrorMessage.isEmpty {
                    Text("Failed resetting password: \(viewModel.requestResetPassErrorMessage)")
                        .foregroundColor(.red)
                }
                
                Button("Send Instructions") {
                    viewModel.requestResetPassword(userEmail: email)
                }
                .buttonStyle(DarkLongButton())
                .onReceive(viewModel.$resetPasswordEmailSent) { emailSent in
                    if emailSent {
                        withAnimation {
                            showCheckEmail.toggle()
                        }
                    }
                }
                
                Spacer()

            }
            .padding([.leading, .trailing], 10)
            .padding()
            
            if showCheckEmail {
                CheckYourEmailView(showCheckEmail: $showCheckEmail, showResetPassowrd: $showResetPassword)
                    .transition(.move(edge: .bottom))
                    .environmentObject(viewModel)
            }
        }
        .zIndex(2.0)
        .ignoresSafeArea()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(showResetPassword: .constant(true), signInPresented: .constant(false) )
    }
}
