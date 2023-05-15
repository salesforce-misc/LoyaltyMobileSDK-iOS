//
//  PaymentDetailsView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentDetailsView: View {
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
	@EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject private var profileVM: ProfileViewModel
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
								await orderDetailsVM.createOrder(clearable: profileVM, memberId: memberId, membershipNumber: membershipNumber)
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
