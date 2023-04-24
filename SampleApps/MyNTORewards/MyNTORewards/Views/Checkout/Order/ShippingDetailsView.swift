//
//  ShippingDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ShippingDetailsView: View {
    var body: some View {
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
			AddressView()
				.cornerRadius(16, corners: .allCorners)
				.padding(.horizontal, 24)
		}
		.background(Color(hex: "#FAFBFC"))
    }
}

struct ShippingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShippingDetailsView()
    }
}
