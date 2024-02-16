//
//  ReferralListSuccessView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 15/02/24.
//

import SwiftUI
import ReferralMobileSDK

struct ReferralListSuccessView: View {
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
                            ReferralCardView(status: .purchaseCompleted,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                }
                
                if !viewModel.oneMonthAgoReferralsSuccess.isEmpty {
                    VStack {
                        HStack {
                            Text(StringConstants.Referrals.sectionTwoTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.oneMonthAgoReferralsSuccess) { referral in
                            ReferralCardView(status: .purchaseCompleted,
                                         email: referral.referredParty.account.personEmail,
                                         referralDate: referral.referralDate)
                        }
                    }
                    
                }
                
                if !viewModel.threeMonthsAgoReferralsSuccess.isEmpty {
                    VStack {
                        HStack {
                            Text(StringConstants.Referrals.sectionThreeTitle)
                                .font(.referralTimeTitle)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        ForEach(viewModel.threeMonthsAgoReferralsSuccess) { referral in
                            ReferralCardView(status: .purchaseCompleted,
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

#Preview {
    ReferralListSuccessView()
}
