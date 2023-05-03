//
//  PaymentDetailsView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentDetailsView: View {
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
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
				
				NavigationLink {
					OrderPlacedView()
						.environmentObject(orderDetailsVM)
				} label: {
					Text("Confirm Order")
						.onTapGesture {
							Task {
								isScreenLoading = true
								await orderDetailsVM.createOrder()
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
