//
//  ProductReviewView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ProductReviewView: View {
    var body: some View {
		VStack {
			EmptyStateView(title: "No reviews yet.",
						   subTitle: "After someone reviews the product, you’ll see the reviews here.")
			Spacer()
		}
    }
}

struct ProductReviewScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductReviewView()
    }
}
