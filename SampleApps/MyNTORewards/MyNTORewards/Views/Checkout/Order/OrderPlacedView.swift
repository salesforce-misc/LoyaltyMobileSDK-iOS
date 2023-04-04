//
//  OrderPlacedView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/03/23.
//

import SwiftUI

struct OrderPlacedView: View {
	@EnvironmentObject private var promotionVM: PromotionViewModel
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
    var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 16) {
				Image("circle_checked")
				Text("Order Placed!")
					.font(.productDetailTitleText)
				Text("Your payment is complete, please check the deliver details at the tracking page")
					.font(.aggreementText)
					.multilineTextAlignment(.center)
					.lineSpacing(6)
			}
			.padding(75)
			Spacer()
			Button{
				promotionVM.isCheckoutNavigationActive = false
			} label: {
				Text("Continue Shopping")
					.font(.boldButtonText)
			}
				.buttonStyle(DarkFlexibleButton())
				.frame(width: 220)
		}
		.task {
			do {
				let details = try await orderDetailsVM.getOrderDetails()
			} catch {
				print("Error fetching order details..")
			}
		}
		.navigationBarBackButtonHidden(true)
    }
}

struct OrderPlacedView_Previews: PreviewProvider {
    static var previews: some View {
        OrderPlacedView()
    }
}
