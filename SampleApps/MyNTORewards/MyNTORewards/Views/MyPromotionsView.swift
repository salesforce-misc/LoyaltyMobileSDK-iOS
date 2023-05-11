//
//  RewardsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct MyPromotionsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @State var offerTabSelected: Int = 0
    let barItems = ["Unenrolled", "Active", "All"]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("My Promotions")
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                        .accessibilityIdentifier(AppAccessibilty.Promotion.header)
                    Spacer()
                    Image("ic-search")
                        .padding(.trailing, 15)
                        .accessibilityIdentifier(AppAccessibilty.Promotion.searchImage)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                TopTabBar(barItems: barItems, tabIndex: $offerTabSelected)
            }
            ZStack {
                Color.theme.background
                
                TabView(selection: $offerTabSelected) {
                    
                    unenrolledView
                        .tag(0)
                    activeView
                        .tag(1)
                    allView
                        .tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
            .task {
                do {
                    try await promotionVM.loadUnenrolledPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    Logger.error("Load Unenrolled Promotions Error: \(error)")
                }
            }
            .task {
                do {
                    try await promotionVM.loadActivePromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    Logger.error("Reload Active Promotions Error: \(error)")
                }
            }
            .task {
                do {
                    try await promotionVM.loadAllPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    Logger.error("Load All Promotions Error: \(error)")
                }
            }
        }
        
    }
    
    var unenrolledView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.unenrolledPromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any eligibile promotions to enroll. Please come back later.")
                }
                ForEach(Array(promotionVM.unenrolledPromotions.enumerated()), id: \.offset) { index, promotion in
                    MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
        }
        .refreshable {
            Logger.debug("Reloading unenrolled...")
            do {
                try await promotionVM.fetchUnenrolledPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error("Reload Unenrolled Promotions Error: \(error)")
            }
        }
    }
    
    var activeView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.activePromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any active promotions. Please come back later.")
                }
                ForEach(Array(promotionVM.activePromotions.enumerated()), id: \.offset) { index, promotion in
                    MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
        }
        .refreshable {
            Logger.debug("Reloading active...")
            do {
                try await promotionVM.fetchActivePromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error("Load Active Promotions Error: \(error)")
            }
        }
        
    }
    
    var allView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.allEligiblePromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any eligibile promotions. Please come back later.")
                }
                ForEach(Array(promotionVM.allEligiblePromotions.enumerated()), id: \.offset) { index, promotion in
                    MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
        }
        .refreshable {
            Logger.debug("Reloading all...")
            do {
                try await promotionVM.fetchAllPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error("Reload All Promotions Error: \(error)")
            }
        }
    }
    
}

struct MyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPromotionsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
