//
//  OrderDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct OrderDetailsView: View {
	@StateObject private var viewModel = OrderDetailsViewModel(index: 0)
	@State private var index = 0
	let tabbarItems = ["1. Shipping", "2. Payment"]
    var body: some View {
		VStack {
			TabView(selection: $index) {
				ShippingDetailsView(selectedIndex: $index)
					.tag(0)
				PaymentDetailsView()
					.environmentObject(viewModel)
					.tag(1)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
		}
		.loytaltyNavigationTitle("Order Details")
		.loyaltyNavBarSearchButtonHidden(true)
		.loyaltyNavBarTabBar(TopTabBar(barItems: tabbarItems, tabIndex: $index))
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
