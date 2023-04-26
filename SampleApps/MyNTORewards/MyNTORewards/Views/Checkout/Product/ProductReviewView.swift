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
			EmptyStateView(title: "No reviews, yet.",
						   subTitle: "There are no reviews yet. Please come back later.")
			Spacer()
		}
    }
}

struct ProductReviewScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductReviewView()
    }
}
