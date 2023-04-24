//
//  OrderDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct OrderDetailsView: View {
	@State private var tabIndex = 0
	let tabbarItems = ["1. Shipping", "2. Payment"]
    var body: some View {
		VStack {
			NavigationBarView()
			HStack {
				Text("Order Details")
					.font(.orderDetailTitleText)
					.padding()
				Spacer()
			}
			TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
			TabView(selection: $tabIndex) {
				ShippingDetailsView()
					.tag(0)
				Color.gray
					.tag(1)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
		}
		.edgesIgnoringSafeArea(.bottom)
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
