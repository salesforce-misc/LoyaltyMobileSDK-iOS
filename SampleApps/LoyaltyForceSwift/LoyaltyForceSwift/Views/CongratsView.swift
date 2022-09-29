//
//  CongratsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/29/22.
//

import SwiftUI

struct CongratsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    
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
            
            Text("Congratulations!!!")
                .font(.congratsTitle)
                .padding(.top, 40)
                .padding()
            
            Text("Welcome to our Loyalty group. Enjoy more benefits and offers with every purchase.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 40)
            
            Text("Please check your registered email id **\(email)** for more details.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 70)
                .padding([.leading, .trailing], 50)
            
            Button(action: {
                dismiss()
            }) {
                Text("Shop Now!")
            }
            .buttonStyle(DarkLongButton())

            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView(email: "julia.green@gmail.com")
    }
}
