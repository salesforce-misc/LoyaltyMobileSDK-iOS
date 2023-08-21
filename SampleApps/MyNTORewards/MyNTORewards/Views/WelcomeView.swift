//
//  WelcomeView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 5/31/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var welcomePresented: Bool
    @Binding var signInPresented: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Image("img-congrats")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Image("img-gift")
                            .offset(x: 0, y: 100)
                    )
                Image("img-purple-ellipse")
                    .offset(x: 80, y: -115)
                
                Image("img-orange-ellipse")
                    .offset(x: -195, y: 50)
            }
            
            Text("Welcome on board!")
                .font(.congratsTitle)
                .padding(.top, 40)
                .padding()
            
            Text("We're thrilled that you joined NTO Insider. You're on your way to earning points and receiving exclusive rewards.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 40)
            
            Text("Log in with your username and password.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 60)
                .padding([.leading, .trailing], 50)
            
            Button(action: {
                welcomePresented = false
                signInPresented = true
            }) {
                Text("Log In")
            }
            .buttonStyle(DarkLongButton())

            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(welcomePresented: .constant(true), signInPresented: .constant(false))
    }
}
