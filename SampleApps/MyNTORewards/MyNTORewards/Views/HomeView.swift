//
//  HomeView.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                
                ScrollView(showsIndicators: false) {
//                        Rectangle()
//                            .frame(height: 400)
//                            .foregroundColor(Color.theme.accent)
//                            .padding(.top, -400)
                    HStack {
                        Text("Hello \(rootVM.member?.firstName.capitalized ?? ""),")
                            .padding(.leading, 15)
                        Spacer()
                        Text("\(String(profileVM.profile?.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName) ?? 0)) \(AppSettings.Defaults.rewardCurrencyName)")
                            .padding(.trailing, 15)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.backgroundPink)
                    //.padding(.top, -10)
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
                        .padding(.top, 40)
                        .padding(.bottom, 40)

                    /* Post MVP
                    // Redeem Points
                    RedeemPointsView()
                     */

                    VouchersView()
                        .padding(.bottom, 100)

                }
                .background(Color.theme.background)
                .task {
                    do {
                        try await profileVM.getProfileData(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
                    } catch {
                        print("Fetch profile Error: \(error)")
                    }
                }
                .refreshable {
                    print("Reloading home...")
                    Task {
                        do {
                            try await profileVM.fetchProfile(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
                        } catch {
                            print("Reload Profile Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await promotionVM.fetchCarouselPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                        } catch {
                            print("Reload Promotions Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await voucherVM.reloadVouchers(membershipNumber: rootVM.member?.membershipNumber ?? "")
                        } catch {
                            print("Reload Vouchers Error: \(error)")
                        }
                    }
                    
                }
                
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(Tab.home.rawValue))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
    }
}

