//
//  OrderPlacedView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/03/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct OrderPlacedView: View {
	@EnvironmentObject private var promotionVM: PromotionViewModel
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    @EnvironmentObject private var vouchersVM: VoucherViewModel
	@State var orderNumber = ""
	
    var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 16) {
				Image("circle_checked")
				Text("Your Order \(orderNumber) is Placed.")
					.font(.productDetailTitleText)
					.multilineTextAlignment(.center)
				Text("You can view the delivery status on the tracking page.")
					.font(.aggreementText)
					.multilineTextAlignment(.center)
					.lineSpacing(6)
			}
			.padding(75)
			Spacer()
			Button {
                promotionVM.isCheckoutNavigationActive = false
                Task {
                    let memberId = profileVM.profile?.loyaltyProgramMemberID
                    let membershipNumber = profileVM.profile?.membershipNumber
                    try await orderDetailsVM.reloadAfterOrderPlaced(reloadables: [transactionVM, vouchersVM, profileVM],
                                                    memberId: memberId,
                                                    membershipNumber: membershipNumber)
                }
                
			} label: {
				Text("Continue Shopping")
					.font(.boldButtonText)
			}
            .buttonStyle(DarkFlexibleButton())
            .frame(width: 220)
		}
		.task {
			do {
				let orderDetails = try await orderDetailsVM.getOrderDetails()
				orderNumber = orderDetails.orderNumber
			} catch {
                Logger.error("Error fetching order details..")
			}
		}
		.navigationBarBackButtonHidden(true)
    }
}

struct OrderPlacedView_Previews: PreviewProvider {
    static var previews: some View {
        OrderPlacedView()
            .environmentObject(dev.promotionVM)
            .environmentObject(dev.orderDetailsVM)
    }
}
