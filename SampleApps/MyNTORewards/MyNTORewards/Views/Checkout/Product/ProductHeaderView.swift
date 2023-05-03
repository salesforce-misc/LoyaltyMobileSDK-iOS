//
//  ProductHeaderView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct ProductHeaderView: View {
	let title: String
	let subTitle: String
	let rating: Float
    var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text(title)
					.font(.smallHeaderText)
				Spacer()
				StarRatingView(rating: rating)
			}
			Text(subTitle)
				.font(.smallSubtitleText)
		}
		.padding(.horizontal)
		.padding(.top)
    }
}

struct ProductHeaderView_Previews: PreviewProvider {
    static var previews: some View {
		ProductHeaderView(title: "STOP", subTitle: "Women Flight Jacket", rating: 4)
    }
}
