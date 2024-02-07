//
//  PromotionGatewayView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 07/02/24.
//

import SwiftUI
import LoyaltyMobileSDK

struct PromotionGatewayView: View {
    @StateObject private var viewModel = PromotionGateWayViewModel()
    @EnvironmentObject private var rootVM: AppRootViewModel
    let promotion: PromotionResult
    @Binding var processing: Bool
    
    var body: some View {
        Group {
            switch viewModel.promotionStatusApiState {
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
                if viewModel.isReferralPromotion {
                    if viewModel.enrolledToPromotion {
                        ReferAFriendView(promotionCode: viewModel.promoCode )
                    } else {
                        JoinAndReferView(showReferAFriendView: .constant(true))
                    }
                } else {
                    MyPromotionDetailView(promotion: promotion, processing: $processing)
                }
            }
        }.onAppear {
            checkEnrollmentStatus()
        }
    }
    
    func checkEnrollmentStatus() {
        Task {
            let memberId = rootVM.member?.loyaltyProgramMemberId ?? ""
            await viewModel.getPromotionTypeAndStatus(promotionId: promotion.id, loyaltyProgramMemberId: memberId)
        }
    }
}

//#Preview {
//    PromotionGatewayView(promotion: dev.promotion, processing: .constant(false))
//}
