//
//  OrderDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct OrderDetailsView: View {
	@ObservedObject private var viewModel = OrderDetailsViewModel()
	@State private var index = 0
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
			TopTabBar(barItems: tabbarItems, tabIndex: $viewModel.selectedIndex)
			TabView(selection: $viewModel.selectedIndex) {
				ShippingDetailsView()
					.tag(0)
				PaymentDetailsView()
					.tag(1)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
		}
		.environmentObject(viewModel)
//		.edgesIgnoringSafeArea(.bottom)
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
