//
//  ShippingDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ShippingDetailsView: View {
    @EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
	@Binding var orderDetailsIndex: Int
	var body: some View {
		VStack {
			VStack {
				HStack {
					Text("Address")
						.font(.smallHeaderText)
					Spacer()
					Button {} label: {
						Text("Add a New Address")
							.font(.smallHeaderText)
					}
				}
				.padding(24)
				AddressView()
                    .environmentObject(orderDetailsVM)
					.cornerRadius(16, corners: .allCorners)
					.padding(.horizontal, 24)
			}
            Spacer()
			Button("Deliver to this Address") {
				withAnimation {
                    orderDetailsIndex = 1
				}
			}
			.buttonStyle(DarkFlexibleButton())
		}
		.background(Color(hex: "#FAFBFC"))
	}
}

struct ShippingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		ShippingDetailsView(orderDetailsIndex: .constant(0))
            .environmentObject(dev.orderDetailsVM)
            .environmentObject(dev.rootVM)
    }
}
