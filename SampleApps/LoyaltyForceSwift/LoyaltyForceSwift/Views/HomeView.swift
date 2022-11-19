//
//  HomeView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @Binding var selectedTab: Tab
    
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
                        Text("Hello \(rootVM.member?.firstName.capitalized ?? ""),")
                            .padding(.leading, 15)
                        Spacer()
                        Text("\(String(profileVM.profile?.getRewardPoints() ?? 0)) Points")
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
                    PromotionCarouselView(selectedTab: $selectedTab)
                        .frame(height: 400)
                        .padding(.top, 80)
                        .padding(.bottom, 80)
                   
                    /* Post MVP
                    // Redeem Points
                    RedeemPointsView()
                     */
                    
                    VouchersView()
                    
                }
                .task {
                    do {
                        try await profileVM.getProfileData(memberId: rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? "")
                    } catch {
                        print("Fetch profile Error: \(error)")
                    }
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
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.home))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
    }
}

