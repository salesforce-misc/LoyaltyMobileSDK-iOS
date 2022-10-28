//
//  HomeView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                ScrollView(showsIndicators: false) {
                    Rectangle()
                        .frame(height: 400)
                        .foregroundColor(Color.theme.accent)
                        .padding(.top, -354)
                    HStack {
                        Text("Welcome, \(viewModel.member?.firstName.capitalized ?? "") \(viewModel.member?.lastName.capitalized ?? "")!")
                            .padding(.leading, 15)
                        Spacer()
                        Text("17850 Points")
                            .padding(.trailing, 15)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.backgroundPink)
                    .padding(.top, -10)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .shadow(
                                color: Color.gray.opacity(0.4),
                                radius: 5,
                                x: 0,
                                y: 0
                            )
                    )
                    
                    // Offers & Promotions
                    //OffersCarouselView()
                    PromotionCarouselView()
                        .frame(height: 400)
                        .padding(.top, 80)
                        .padding(.bottom, 20)
                    
                    // Redeem Points
                    RedeemPointsView()
                }
                
                
                VStack{
                    VStack(spacing: 0) {
                        HStack {
                            Image("ic-logo-home")
                                .padding(.leading, 15)
                            Spacer()
                            Image("ic-magnifier")
                                .padding(.trailing, 15)
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.theme.accent)
                    }
                    Spacer()
                }
                
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(dev.rootVM)
    }
}

