//
//  ProductView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct ProductView: View {
	@State private var tabIndex = 0
	@State private var moveToOrderDetails = false
	
	var tabbarItems: [String] = ["Details", "Reviews", "T&C"]
	
	var body: some View {
		VStack(alignment: .center) {
			TabView(selection: $tabIndex) {
				ProductDetailsView()
					.tag(0)
					.padding(.horizontal, 4.5)
				ProductReviewView()
					.tag(1)
				ProductTermsAndConditionsView()
					.tag(2)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			LoyaltyConditionalNavLink(isActive: $moveToOrderDetails) {
				OrderDetailsView()
			} label: {
				Button("Buy Now") {
					moveToOrderDetails.toggle()
				}
				.buttonStyle(DarkLongButton())
			}
		}
		.loytaltyNavigationTitle("Outdoor Collection")
		.loyaltyNavigationSubtitle("Double points on Outdoor Product Category")
		.loyaltyNavBarSearchButtonHidden(true)
		.loyaltyNavBarTabBar(TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex, tabAlignment: .center))
		.background(Color(hex: "#F1F3FB"))
	}
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
