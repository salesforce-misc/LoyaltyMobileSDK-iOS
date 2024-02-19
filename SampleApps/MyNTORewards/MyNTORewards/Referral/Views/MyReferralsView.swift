//
//  MyReferralsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/20/23.
//

import SwiftUI
import ReferralMobileSDK

struct MyReferralsView: View {
    @EnvironmentObject internal var viewModel: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var routerPath: RouterPath
    @State private var tabIndex = 0
    @State var showPromotionView = false
    var tabbarItems = [StringConstants.Referrals.successTab, StringConstants.Referrals.inProgressTab]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(StringConstants.Referrals.referralsTitle)
                    .font(.congratsTitle)
                    .padding(.leading, 15)
                    .accessibilityIdentifier(AppAccessibilty.Referrals.referralsViewTitle)
                Spacer()
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(.white)
            
            ZStack {
                Color.theme.backgroundPink
                
                ScrollView {
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 328, height: 204)
                                .cornerRadius(10, corners: .allCorners)
                                .foregroundColor(Color.theme.referralCardBackground)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(StringConstants.Referrals.infoTitle)
                                        .font(.referralText)
                                        .padding(10)
                                    Spacer()
                                }
                                
                                HStack(spacing: 30) {
                                    VStack(alignment: .leading) {
                                        Text(StringConstants.Referrals.sent)
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.sent] ?? 0)**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text(StringConstants.Referrals.vouchersEarned)
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.voucherEarned] ?? 0)**")
                                            .font(.referralBoldText)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(StringConstants.Referrals.accepted)
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.accepted] ?? 0)**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text(StringConstants.Referrals.pointsEarned)
                                            .font(.referralText)
                                            .opacity(0)
                                        Text("**0**")
                                            .font(.referralBoldText)
                                            .opacity(0)
                                    }
                                }
                                .padding(.leading, 30)
                                
                                HStack {
                                    Spacer()
                                    Button(StringConstants.Referrals.referButton) {
                                        // Refer
                                        showPromotionView.toggle()
                                    }
                                    .buttonStyle(LightShortReferralsButton())
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                            }
                            .foregroundColor(Color.white)
                            .frame(width: 328, height: 204)
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-1")
                                    .padding(.top, 6)
                                    .padding(.trailing, 8)
                                
                            }
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-2")
                                    .padding(.top, 13)
                                    .padding(.trailing, 34)
                            }
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-3")
                                    .padding(.top, 44)
                                    .padding(.trailing, 10)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-4")
                                    .padding(.top, 48)
                                    .padding(.leading, 8)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-5")
                                    .padding(.top, 52)
                                    .padding(.leading, 41)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-6")
                                    .padding(.top, 130)
                                    .padding(.leading, 13)
                            }
                            
                        }
                        .padding()
                        
                        TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
                        
                        TabView(selection: $tabIndex) {
                            ReferralListSuccessView()
                                .environmentObject(viewModel)
                                .tag(0)
                            ReferralListInProcessView()
                                .environmentObject(viewModel)
                                .tag(1)
                        }
                        .frame(minHeight: 500, maxHeight: .infinity)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .padding(.bottom, 100)
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPromotionView) {
            DefaultPromotionGateWayView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    MyReferralsView()
        .environmentObject(ReferralViewModel())
        .environmentObject(AppRootViewModel())
}
