//
//  ShippingDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ShippingDetailsView: View {
	@Binding var selectedIndex: Int
	var body: some View {
		VStack {
			ScrollView {
				HStack {
					Text("Shipping Address")
						.font(.smallHeaderText)
					Spacer()
					Button {} label: {
						Text("Add New Address")
							.font(.smallHeaderText)
					}
				}
				.padding(24)
				AddressView(selectedIndex: $selectedIndex)
					.cornerRadius(16, corners: .allCorners)
					.padding(.horizontal, 24)
			}
			Button("Deliver to This Address") {
				withAnimation {
					selectedIndex = 1
				}
			}
			.buttonStyle(DarkFlexibleButton())
		}
		.background(Color(hex: "#FAFBFC"))
	}
}

struct ShippingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		ShippingDetailsView(selectedIndex: .constant(0))
    }
}
