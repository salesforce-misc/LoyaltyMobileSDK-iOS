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
				
				NavigationLink(isActive: $orderDetailsVM.isOrderPlacedNavigationActive) {
					OrderPlacedView()
						.environmentObject(orderDetailsVM)
				} label: {
					Text("Confirm Order")
						.onTapGesture {
							Task {
								let memberId = profileVM.profile?.loyaltyProgramMemberID
								let membershipNumber = profileVM.profile?.membershipNumber
								isScreenLoading = true
								do {
									try await orderDetailsVM.createOrder(
                                        reloadables: [transactionVM, vouchersVM, profileVM],
                                        productVM: productVM,
                                        profileVM: profileVM,
                                        memberId: memberId,
                                        membershipNumber: membershipNumber)
								} catch {
                                    Logger.error("Unable to create order: \(error.localizedDescription)")
								}
								isScreenLoading = false
							}
						}
						.longFlexibleButtonStyle()
				}
			}
			.background(Color(hex: "#F1F3FB"))
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
    }
}
