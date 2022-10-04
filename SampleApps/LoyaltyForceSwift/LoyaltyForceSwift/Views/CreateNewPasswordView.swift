//
//  CreateNewPasswordView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/3/22.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
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
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: passwordConfirmation != password ? 2 : 0)
                        .padding([.leading, .trailing])
                    )
                
                Button("Reset Password") {
                    
                }
                .buttonStyle(DarkLongButton())
                
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .padding()
            
        }
        .zIndex(2.0)
        .ignoresSafeArea()
    }
}

struct CreateNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPasswordView(showCreateNewPassword: .constant(false))
    }
}
