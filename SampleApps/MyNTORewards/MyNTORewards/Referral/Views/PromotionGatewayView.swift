//
//  PromotionGatewayView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 07/02/24.
//

import SwiftUI
import LoyaltyMobileSDK

struct PromotionGatewayView: View {
	@StateObject private var viewModel: PromotionGateWayViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    @Environment(\.dismiss) private var dismiss
    let promotion: PromotionResult
    @Binding var processing: Bool
	
	init(promotion: PromotionResult, processing: Binding<Bool>) {
		self.promotion = promotion
		self._processing = processing
#if DEBUG
		if UITestingHelper.isUITesting {
			self._viewModel = StateObject(wrappedValue: PromotionGateWayViewModel(devMode: true,
																				  mockPromotionStatusApiState: UITestingHelper.mockPromotionStatusApiState,
																				  mockPromotionScreenType: UITestingHelper.mockPromotionScreenType
																				 ))
		} else {
			self._viewModel = StateObject(wrappedValue: PromotionGateWayViewModel())
		}
#else
		_playGameViewModel = StateObject(wrappedValue: PlayGameViewModel())
#endif
		
	}
    
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
                case .loyaltyPromotion:
                    MyPromotionDetailView(promotion: promotion, processing: $processing)
                case .joinReferralPromotion:
                    JoinAndReferView(promotion: viewModel.promotionInfo).environmentObject(viewModel)
                case .referFriend:
                    ReferAFriendView(promotionCode: viewModel.promotionInfo?.promotionCode ?? "", promotion: viewModel.promotionInfo)
                case .joinPromotionError:
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
                        }.onDisappear(perform: {
                            viewModel.displayError = (false, "")
                        })
                }
            }
        }.onAppear {
            checkEnrollmentStatus()
        }
    }
    
    func checkEnrollmentStatus() {
        Task {
            let contactId = rootVM.member?.contactId ?? ""
            await viewModel.getPromotionType(promotionId: promotion.id, contactId: contactId)
        }
    }
}
