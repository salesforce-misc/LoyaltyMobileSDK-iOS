//
//  MyReferralsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/20/23.
//

import SwiftUI
import ReferralMobileSDK

struct MyReferralsView: View {
    
    @StateObject var viewModel = MyReferralsViewModel()
    @State private var tabIndex = 0
    @State var showReferAFriendView = false
    var tabbarItems = ["Success", "In Progress"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Referrals")
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
                                    Text("**YOUR REFERRALS**: Last 90 Days")
                                        .font(.referralText)
                                        .padding(10)
                                    Spacer()
                                }
                                
                                HStack(spacing: 30) {
                                    VStack(alignment: .leading) {
                                        Text("SENT")
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.sent] ?? 0)**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text("VOUCHERS EARNED")
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.voucherEarned] ?? 0)**")
                                            .font(.referralBoldText)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("ACCEPTED")
                                            .font(.referralText)
                                        Text("**\(viewModel.promotionStageCounts[.accepted] ?? 0)**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text("POINTS EARNED")
                                            .font(.referralText)
                                            .opacity(0)
                                        Text("**1200**")
                                            .font(.referralBoldText)
                                            .opacity(0)
                                    }
                                }
                                .padding(.leading, 30)
                                
                                HStack {
                                    Spacer()
                                    Button("Refer a Friend Now!") {
                                        // Refer
                                        showReferAFriendView.toggle()
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
                            SuccessView()
                                .environmentObject(viewModel)
                                .tag(0)
                            InProcessView()
                                .environmentObject(viewModel)
                                .tag(1)
                        }
                        .frame(height: 1000)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showReferAFriendView) {
            ReferAFriendView()
                .environmentObject(viewModel)
        }
        .task {
            do {
                try await viewModel.loadAllReferrals(devMode: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        .refreshable {
            do {
                try await viewModel.loadAllReferrals(reload: true, devMode: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

struct SuccessView: View {
    @EnvironmentObject var viewModel: MyReferralsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Referrals")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.recentReferralsSuccess) { referral in
                ReferralCard(status: .purchaseCompleted, email: referral.clientEmail, referralDate: referral.referralDate)
            }
            Text("Referrals one month ago")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.oneMonthAgoReferralsSuccess) { referral in
                ReferralCard(status: .purchaseCompleted, email: referral.clientEmail, referralDate: referral.referralDate)
            }
            Text("Referrals older than three month")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.threeMonthsAgoReferralsSuccess) { referral in
                ReferralCard(status: .purchaseCompleted, email: referral.clientEmail, referralDate: referral.referralDate)
            }
            Spacer()
        }
    }
}

struct InProcessView: View {
    @EnvironmentObject var viewModel: MyReferralsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Referrals")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.recentReferralsInProgress) { referral in
                ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                             email: referral.clientEmail,
                             referralDate: referral.referralDate)
            }
            Text("Referrals one month ago")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.oneMonthAgoReferralsInProgress) { referral in
                ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                             email: referral.clientEmail,
                             referralDate: referral.referralDate)
            }
            Text("Referrals older than three month")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ForEach(viewModel.threeMonthsAgoReferralsInProgress) { referral in
                ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                             email: referral.clientEmail,
                             referralDate: referral.referralDate)
            }
            Spacer()
        }
    }
}

struct ReferralCard: View {
    let status: ReferralStatus
    let email: String
    let referralDate: String
    
    var body: some View {
        VStack {
            HStack {
                Assets.getReferralStatusIcon(status: status)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("**\(email)**")
                    .font(.referralCardText)
                Spacer()
            }
            .padding(.horizontal, 10)
            HStack {
                Text(referralDate)
                    .font(.referralCardText)
                Spacer()
                Text("**\(status.rawValue)**")
                    .font(.referralStatus)
                    .foregroundColor(status == .purchaseCompleted ? Color.theme.purchaseCompleted : .black)
            }
            .padding(.leading, 44)
            .padding(.trailing, 10)
        }
        .frame(width: 343, height: 66)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    MyReferralsView()
}
