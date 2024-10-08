//
//  PaymentDetailsView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct PaymentDetailsView: View {
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
	@EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject private var profileVM: ProfileViewModel
	@EnvironmentObject private var productVM: ProductViewModel
	@EnvironmentObject private var transactionVM: TransactionViewModel
	@EnvironmentObject private var vouchersVM: VoucherViewModel
	@EnvironmentObject private var gameZoneViewModel: GameZoneViewModel
	@State private var isScreenLoading = false
	
    var body: some View {
		ZStack {
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading, spacing: 24) {
						OrderVoucherView()
							.cornerRadius(16, corners: .allCorners)
						AmountPayableView()
						PaymentCardView()
							.cornerRadius(16, corners: .allCorners)
					}
					.padding()
				}
				
                Text("Confirm Order")
                    .onTapGesture {
                        Task {
                            let membershipNumber = profileVM.profile?.membershipNumber
                            isScreenLoading = true
                            do {
                                try await orderDetailsVM.createOrder(
                                    reloadables: [transactionVM, vouchersVM, profileVM],
                                    productVM: productVM,
                                    profileVM: profileVM,
                                    membershipNumber: membershipNumber)
								if orderDetailsVM.gameParticipantRewardId.isEmpty {
									orderDetailsVM.isOrderPlacedNavigationActive = true
								} else {
									orderDetailsVM.gameDefinition = try await gameZoneViewModel.fetchGame(for: rootVM.member?.loyaltyProgramMemberId ?? "",
																										  gameParticipantRewardId: orderDetailsVM.gameParticipantRewardId)
									orderDetailsVM.isOrderPlacedWithGameNavigationActive = true
								}
								
                            } catch {
                                Logger.error("Unable to create order: \(error.localizedDescription)")
                            }
                            isScreenLoading = false
                        }
					}
					.longFlexibleButtonStyle()
					.navigationDestination(isPresented: $orderDetailsVM.isOrderPlacedNavigationActive) {
						OrderPlacedView()
							.environmentObject(orderDetailsVM)
					}
					.navigationDestination(isPresented: $orderDetailsVM.isOrderPlacedWithGameNavigationActive) {
						OrderPlacedGameView(game: orderDetailsVM.gameType ?? .scratchCard)
							.environmentObject(orderDetailsVM)
							.navigationBarBackButtonHidden()
					}
			}
            .background(Color.theme.productBackground)
            
			if isScreenLoading {
				LoadingScreen()
			}
		}
    }
}

struct LoadingScreen: View {
	var body: some View {
		ZStack {
			Color(white: 0.5, opacity: 0.2)
			ProgressView()
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		PaymentDetailsView()
            .environmentObject(dev.orderDetailsVM)
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
            .environmentObject(dev.productVM)
            .environmentObject(dev.transactionVM)
            .environmentObject(dev.voucherVM)
        
    }
}
