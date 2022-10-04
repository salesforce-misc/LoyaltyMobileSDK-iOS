//
//  CheckYourEmailView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct CheckYourEmailView: View {
    
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    @Binding var showCheckEmail: Bool
    @Binding var showResetPassowrd: Bool
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 15) {
                Spacer()
                Image("ic-email")
                
                Text("Check you email")
                    .font(.congratsTitle)
                
                Text("We have sent a password recovery instructions to your email.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .foregroundColor(Color.theme.superLightText)
                    .padding([.leading, .trailing], 40)
                
                Button("Open Email App") {
                    
                }
                .buttonStyle(DarkLongButton())
                .padding(.top, 20)
                
                Text("Skip, I'll confirm later")
                    .foregroundColor(Color.theme.accent)
                    .font(.skipText)
                    .onTapGesture {
                        withAnimation {
                            showResetPassowrd = false
                            showCheckEmail = false
                        }
                        viewModel.resetPasswordEmailSent = false
                    }
                
                Spacer()
                Spacer()
        
                
                Text("Did not receive the email? Check your spam folder, or \(Text("you may try to reset again.").foregroundColor(Color.theme.accent))")
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .foregroundColor(Color.theme.superLightText)
                .padding([.leading, .trailing], 40)
                .padding(.bottom, 50)
                .onTapGesture {
                    withAnimation {
                        showCheckEmail.toggle()
                    }
                    viewModel.resetPasswordEmailSent = false
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
    }
}
