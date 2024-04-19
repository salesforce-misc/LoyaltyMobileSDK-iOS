//
//  ReferralListInProcessView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 15/02/24.
//

import SwiftUI
import  ReferralMobileSDK

struct ReferralListInProcessView: View {
    @EnvironmentObject var viewModel: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.recentReferralsInProgress.isEmpty {
                    VStack {
                        HStack {
                            Text(StringConstants.Referrals.sectionOneTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.recentReferralsInProgress) { referral in
                            ReferralCardView(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.oneMonthAgoReferralsInProgress.isEmpty {
                    VStack {
                        HStack {
                            Text(StringConstants.Referrals.sectionTwoTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.oneMonthAgoReferralsInProgress) { referral in
                            ReferralCardView(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.threeMonthsAgoReferralsInProgress.isEmpty {
                    VStack {
                        HStack {
                            Text(StringConstants.Referrals.sectionThreeTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.threeMonthsAgoReferralsInProgress) { referral in
                            ReferralCardView(status: PromotionStageType(rawValue: referral.currentPromotionStage.type)?.correspondingReferralStatus ?? .unknown,
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
                try await viewModel.loadAllReferrals(membershipNumber: rootVM.member?.membershipNumber ?? "", reload: true)
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        
    }
}

#Preview {
    ReferralListInProcessView()
}
