//
//  CongratsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/29/22.
//

import SwiftUI

struct CongratsView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
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
            
            Text("Welcome on board!")
                .font(.congratsTitle)
                .padding(.top, 40)
                .padding()
            
            Text("We're thrilled that you joined \(viewModel.member?.enrollmentDetails.loyaltyProgramName ?? "our loyalty program"). You're on your way to earning points and receiving exclusive rewards.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 40)
            
            Text("We've sent an email to **\(email)** with more details.")
                .font(.congratsText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 60)
                .padding([.leading, .trailing], 50)
            
            Button(action: {
                dismiss()
                appViewRouter.signedIn = true
                appViewRouter.currentPage = .navTabsPage(selectedTab: Tab.home.rawValue)
            }) {
                Text("Shop Now")
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
            .environmentObject(dev.rootVM)
    }
}
