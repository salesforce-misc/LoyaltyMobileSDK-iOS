//
//  MyReferralsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/20/23.
//

import SwiftUI
import ReferralMobileSDK

struct MyReferralsView: View {
    
    @EnvironmentObject private var viewModel: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    @State private var tabIndex = 0
    @State var showReferAFriendView = false
    @State var showJoinandReferView = false
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
                                
                                if !showJoinandReferView {
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
                                            Text("**0**")
                                                .font(.referralBoldText)
                                                .opacity(0)
                                        }
                                    }
                                    .padding(.leading, 30)
                                } else {
                                    HStack(spacing: 30) {
                                        VStack(alignment: .leading) {
                                            Text("SENT")
                                                .font(.referralText)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                                .padding(.bottom)
                                            Text("VOUCHERS EARNED")
                                                .font(.referralText)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("ACCEPTED")
                                                .font(.referralText)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                                .padding(.bottom)
                                            Text("POINTS EARNED")
                                                .font(.referralText)
                                                .opacity(0)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                                .opacity(0)
                                        }
                                    }
                                    .padding(.leading, 30)
                                }
                                
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
                        .frame(minHeight: 500, maxHeight: .infinity)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showReferAFriendView) {
            ReferAFriendView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showJoinandReferView) {
            JoinAndReferView()
                .interactiveDismissDisabled()
                .presentationDetents([.height(480)])
        }
        .task {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", devMode: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        .refreshable {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", reload: true, devMode: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

struct SuccessView: View {
    @EnvironmentObject var viewModel: ReferralViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.recentReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text("Recent Referrals")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.recentReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, email: referral.referredParty.account.personEmail, referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.oneMonthAgoReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text("Referrals one month ago")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.oneMonthAgoReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, email: referral.referredParty.account.personEmail, referralDate: referral.referralDate)
                        }
                    }

                }
                      
                if !viewModel.threeMonthsAgoReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text("Referrals older than three month")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.threeMonthsAgoReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, email: referral.referredParty.account.personEmail, referralDate: referral.referralDate)
                        }
                    }
                }
                if viewModel.recentReferralsSuccess.isEmpty &&
                    viewModel.oneMonthAgoReferralsSuccess.isEmpty &&
                    viewModel.threeMonthsAgoReferralsSuccess.isEmpty {
                    EmptyStateView(title: "No Referrals Found", subTitle: "No succesful referrals found, please start referring your friends now.")
                }
                
                Spacer()
            }
        }
        
    }
}

struct InProcessView: View {
    @EnvironmentObject var viewModel: ReferralViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.recentReferralsInProgress.isEmpty {
                    Group {
                        HStack {
                            Text("Recent Referrals")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.recentReferralsInProgress) { referral in
                            ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.oneMonthAgoReferralsInProgress.isEmpty {
                    Group {
                        HStack {
                            Text("Referrals one month ago")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.oneMonthAgoReferralsInProgress) { referral in
                            ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.threeMonthsAgoReferralsInProgress.isEmpty {
                    Group {
                        HStack {
                            Text("Referrals older than three month")
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.threeMonthsAgoReferralsInProgress) { referral in
                            ReferralCard(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if viewModel.recentReferralsInProgress.isEmpty &&
                    viewModel.oneMonthAgoReferralsInProgress.isEmpty &&
                    viewModel.threeMonthsAgoReferralsInProgress.isEmpty {
                    EmptyStateView(title: "No Referrals Found", subTitle: "No referrals in progress found, please start referring your friends now.")
                }
                
                Spacer()
            }
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
        .environmentObject(ReferralViewModel())
        .environmentObject(AppRootViewModel())
}
