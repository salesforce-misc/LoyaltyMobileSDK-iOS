//
//  PaymentDetailsView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentDetailsView: View {
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
	
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                OrderVoucherView().cornerRadius(16, corners: .allCorners)
                
                AmountPayableView()
                PaymentCardView()
                    .cornerRadius(16, corners: .allCorners)
				NavigationLink(isActive: $orderDetailsVM.isOrderPlacedNavigationActive){
					OrderPlacedView()
						.environmentObject(orderDetailsVM)
				} label: {
					Button{
						Task {
							await orderDetailsVM.createOrder()
						}
					} label: {
						Text("Confirm Order")
							.font(.boldButtonText)
					}
					.buttonStyle(DarkFlexibleButton())
					.padding()
				}
            }.padding()
        }
        .background(Color(hex: "#F1F3FB"))
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsView()
    }
}
