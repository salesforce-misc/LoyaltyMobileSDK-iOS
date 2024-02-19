//
//  DefaultPromotionGateWayView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 16/02/24.
//

import SwiftUI

struct DefaultPromotionGateWayView: View {
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var viewModel: ReferralViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            switch viewModel.enrollmentStatusApiState {
            case .idle:
                Color.theme.background
            case .loading:
                ProgressView()
            case .failed:
                ZStack {
                    Color.theme.background
                    GeometryReader { geometry in
                        ScrollView(.vertical) {
                            VStack {
                                ProcessingErrorView(message: StringConstants.Referrals.genericError)
                                Button {
                                    dismiss()
                                } label: {
                                    Text(StringConstants.Referrals.backButton)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .longFlexibleButtonStyle()
                            }
                            .padding()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                        }.refreshable {
                            checkEnrollmentStatus()
                        }
                    }
                }
                
            case .loaded:
                switch viewModel.promotionScreenType {
                case .joinReferralPromotion:
                    let promotion = getPromotionData(membershipNumber: rootVM.member?.membershipNumber ?? "")
                    JoinAndReferView(isFromMyReferralView: true,
                                     promotion: promotion)
                case .referFriend:
                    let promotion = getPromotionData(membershipNumber: rootVM.member?.membershipNumber ?? "")
                    ReferAFriendView(promotionCode: AppSettings.Defaults.promotionCode, promotion: promotion)
                case .promotionError:
                    ZStack {
                        Color.theme.background
                        VStack {
                            Spacer()
                            ProcessingErrorView(message: viewModel.displayError.1)
                            Spacer()
                            Button {
                                viewModel.displayError = (false, "")
                                dismiss()
                            } label: {
                                Text(StringConstants.Referrals.backButton)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .longFlexibleButtonStyle()
                            .accessibilityIdentifier(AppAccessibilty.Referrals.joinErrorBackButton)
                        }
                    }
                }
            }
        }.onAppear {
            checkEnrollmentStatus()
        }
    }
    
    func checkEnrollmentStatus() {
        Task {
            let contactId = rootVM.member?.contactId ?? ""
            await viewModel.isEnrolledForDefaultPromotion(contactId: contactId)
        }
    }
}

#Preview {
    DefaultPromotionGateWayView()
}
