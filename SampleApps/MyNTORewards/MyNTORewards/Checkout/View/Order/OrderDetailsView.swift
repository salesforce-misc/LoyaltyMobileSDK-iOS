//
//  OrderDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct OrderDetailsView: View {
	@StateObject private var viewModel = OrderDetailsViewModel()
	@State var orderDetailsIndex = 0
    
	let tabbarItems = ["1. Shipping", "2. Payment"]
    var body: some View {
        VStack {
            TabView(selection: $orderDetailsIndex) {
                ShippingDetailsView(orderDetailsIndex: $orderDetailsIndex)
                    .environmentObject(viewModel)
                    .tag(0)
                PaymentDetailsView()
                    .environmentObject(viewModel)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .loytaltyNavigationTitle("Order Details")
        .loyaltyNavBarSearchButtonHidden(true)
        .loyaltyNavBarTabBar(TopTabBar(barItems: tabbarItems, tabIndex: $orderDetailsIndex))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.orderDetailsVM)
            .environmentObject(dev.profileVM)
            .environmentObject(dev.productVM)
            .environmentObject(dev.transactionVM)
            .environmentObject(dev.voucherVM)
    }
}
