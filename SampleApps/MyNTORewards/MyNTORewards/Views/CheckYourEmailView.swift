//
//  CheckYourEmailView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct CheckYourEmailView: View {
    
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @Binding var showCheckEmail: Bool
    @Binding var showResetPassowrd: Bool
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 15) {
                Spacer()
                Image("ic-email")
                
                Text("Password Reset Email Sent")
                    .font(.congratsTitle)
                
                Text("We have sent an email to \(viewModel.email) with the password reset link.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .foregroundColor(Color.theme.superLightText)
                    .padding([.leading, .trailing], 40)
                
                Button("Open Email") {
                    // TODO open default email client
                }
                .buttonStyle(DarkLongButton())
                .padding(.top, 20)
                
                Text("Skip, I’ll check my email later")
                    .foregroundColor(Color.theme.accent)
                    .font(.skipText)
                    .onTapGesture {
                        withAnimation {
                            showResetPassowrd = false
                            showCheckEmail = false
                        }
                        viewModel.userState = .none
                    }
                
                Spacer()
                Spacer()
                
                Text("Didn't receive the email? Check your Spam folder or \(Text("enter another email address.").foregroundColor(Color.theme.accent))")
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .foregroundColor(Color.theme.superLightText)
                .padding([.leading, .trailing], 40)
                .padding(.bottom, 50)
                .onTapGesture {
                    withAnimation {
                        showCheckEmail.toggle()
                    }
                    viewModel.userState = .none
                }
            }
        }
        .zIndex(3.0)
        .ignoresSafeArea()
        
    }
}

struct CheckYourEmailView_Previews: PreviewProvider {
    static var previews: some View {
        CheckYourEmailView(showCheckEmail: .constant(false), showResetPassowrd: .constant(false))
            .environmentObject(AppRootViewModel())
    }
}
