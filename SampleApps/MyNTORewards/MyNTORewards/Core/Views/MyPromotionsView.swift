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
    let barItems = ["All", "Opted In", "Available to Opt In"]
    
    var body: some View {
        NavigationStack {
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
                        
                        allView
                            .tag(0)
                        activeView
                            .tag(1)
                        unenrolledView
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
            }.navigationBarBackButtonHidden()
            .background {
                LoyaltyConditionalNavLink(isActive: $promotionVM.isCheckoutNavigationActive) {
                    ProductView().toolbar(.hidden, for: .tabBar, .navigationBar)
                } label: {
                    EmptyView()
                }
            }
        }
    }
    
    var unenrolledView: some View {
        
        List {
            if promotionVM.unenrolledPromotions.isEmpty {
                EmptyStateView(title: "No promotions yet",
                               subTitle: "When you have eligible promotions to opt for, you’ll see them here.")
            }
            ForEach(Array(promotionVM.unenrolledPromotions.enumerated()), id: \.offset) { index, promotion in
                MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.theme.background)
            .listRowSeparator(.hidden)
        }
        .padding(.top, -20)
        .scrollContentBackground(.hidden)
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
        
        List {
            if promotionVM.activePromotions.isEmpty {
                EmptyStateView(title: "No Promotions, yet.",
                               subTitle: "After you opt for promotions, you’ll see them here.")
            }
            ForEach(Array(promotionVM.activePromotions.enumerated()), id: \.offset) { index, promotion in
                MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
            }
            .listRowBackground(Color.theme.background)
            .listRowSeparator(.hidden)
        }
        .padding(.top, -20)
        .scrollContentBackground(.hidden)
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
        
        List {
            if promotionVM.allEligiblePromotions.isEmpty {
                EmptyStateView(title: "No promotions yet",
                               subTitle: "When you opt for promotions or have eligible promotions to opt for, you’ll see them here.")
            }
            ForEach(Array(promotionVM.allEligiblePromotions.enumerated()), id: \.offset) { index, promotion in
                MyPromotionCardView(accessibilityID: "promotion_\(index)", promotion: promotion)
            }
            .listRowBackground(Color.theme.background)
            .listRowSeparator(.hidden)
        }
        .padding(.top, -20)
        .scrollContentBackground(.hidden)
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
            .environmentObject(dev.imageVM)
    }
}
