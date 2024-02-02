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
    @EnvironmentObject private var routerPath: RouterPath
    @State private var tabIndex = 0
    @State var showReferAFriendView = false
    @State var showEnrollmentView = false
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
                                
                                if !viewModel.showEnrollmentView {
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
                                } else {
                                    HStack(spacing: 30) {
                                        VStack(alignment: .leading) {
                                            Text(StringConstants.Referrals.sent)
                                                .font(.referralText)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                                .padding(.bottom)
                                            Text(StringConstants.Referrals.vouchersEarned)
                                                .font(.referralText)
                                            Text("**0**")
                                                .font(.referralBoldText)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(StringConstants.Referrals.accepted)
                                                .font(.referralText)
                                            Text("**0**")
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
                                }
                                
                                HStack {
                                    Spacer()
                                    Button(StringConstants.Referrals.referButton) {
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
                        
                        if !viewModel.showEnrollmentView {
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
                    .padding(.bottom, 100)
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
        .sheet(isPresented: $showEnrollmentView) {
            JoinAndReferView(showReferAFriendView: $showReferAFriendView)
                .interactiveDismissDisabled()
                .presentationDetents([.height(480)])
        }
        .fullScreenCover(isPresented: $viewModel.displayError.0) {
            Spacer()
            ProcessingErrorView(message: viewModel.displayError.1)
            Spacer()
            Button {
                viewModel.displayError = (false, "")
                routerPath.pathFromMore = []
            } label: {
                Text(StringConstants.Referrals.backButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .longFlexibleButtonStyle()
            .accessibilityIdentifier(AppAccessibilty.Referrals.joinErrorBackButton)
        }
        .task {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "")
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        .refreshable {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", reload: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

struct SuccessView: View {
    @EnvironmentObject var viewModel: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.recentReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text(StringConstants.Referrals.sectionOneTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.recentReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, 
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.oneMonthAgoReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text(StringConstants.Referrals.sectionTwoTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.oneMonthAgoReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, 
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }

                }
                      
                if !viewModel.threeMonthsAgoReferralsSuccess.isEmpty {
                    Group {
                        HStack {
                            Text(StringConstants.Referrals.sectionThreeTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.threeMonthsAgoReferralsSuccess) { referral in
                            ReferralCard(status: .purchaseCompleted, 
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                if viewModel.recentReferralsSuccess.isEmpty &&
                    viewModel.oneMonthAgoReferralsSuccess.isEmpty &&
                    viewModel.threeMonthsAgoReferralsSuccess.isEmpty {
                    EmptyStateView(subTitle: StringConstants.Referrals.noReferralsFound)
                }
                
                Spacer()
            }
            .padding(.bottom, 200)
        }.refreshable {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", reload: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

struct InProcessView: View {
    @EnvironmentObject var viewModel: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.recentReferralsInProgress.isEmpty {
                    Group {
                        HStack {
                            Text(StringConstants.Referrals.sectionOneTitle)
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
                            Text(StringConstants.Referrals.sectionTwoTitle)
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
                            Text(StringConstants.Referrals.sectionThreeTitle)
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
                    EmptyStateView(subTitle: StringConstants.Referrals.noReferralsFound)
                }
                
                Spacer()
            }
            .padding(.bottom, 200)
        }.refreshable {
            do {
                try await viewModel.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", reload: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        
    }
}

struct ReferralCard: View {
    let status: ReferralStatus
    let email: String
    let referralDate: Date
    
    var body: some View {
        HStack(alignment: .center) {
            Assets.getReferralStatusIcon(status: status)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.leading, 8)
            VStack(alignment: .leading, spacing: 6) {
                Text("**\(email)**")
                    .font(.referralCardText)
                HStack {
                    Text(displayDate(referralDate: referralDate))
                        .font(.referralCardText)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                    Text("**\(status.rawValue)**")
                        .font(.referralStatus)
                        .foregroundColor(status == .purchaseCompleted ? Color.theme.purchaseCompleted : Color.theme.superLightText)
                }
                .padding(.trailing, 10)
            }.padding(.vertical, 14)
        }
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
    
    func displayDate(referralDate: Date) -> String {
        let calendar = Calendar.current
        let startOfCurrentDate = calendar.startOfDay(for: Date())
        let startOfInputDate = calendar.startOfDay(for: referralDate)
        
        let components = calendar.dateComponents([.day], from: startOfInputDate, to: startOfCurrentDate)
        let days: Int = components.day ?? 0
        return days == 0 ? "Today" : days == 1 ? "One Day Ago" : days <= 30 ? "\(days) Days Ago" : referralDate.toString()
        
    }
}

#Preview {
    MyReferralsView()
        .environmentObject(ReferralViewModel())
        .environmentObject(AppRootViewModel())
}
