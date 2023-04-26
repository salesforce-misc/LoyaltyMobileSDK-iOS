//
//  ProductView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct ProductView: View {
	@State private var tabIndex = 0
	
	var tabbarItems: [String] = ["Details", "Reviews", "T&C"]
	
	var body: some View {
		VStack(alignment: .leading) {
			NavigationBarView()
			VStack(alignment: .leading, spacing: 8) {
				Text("Outdoor Collection")
					.font(.productDetailTitleText)
				Text("Double points on Outdoor Product Category")
					.font(.productDetailSubtitleText)
			}
			.padding()
			TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
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
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
