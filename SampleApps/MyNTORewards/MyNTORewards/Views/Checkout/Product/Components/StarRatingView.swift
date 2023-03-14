//
//  StarRatingView.swift
//
//
//  Created by Vasanthkumar Velusamy on 06/03/23.
//

import SwiftUI

struct StarRatingView: View {
	private let MAX_RATING: Float = 5.0
	private let COLOR = Color.orange
	
	let rating: Float
	private let fullCount: Int
	private let isHalfPresent: Bool
	private let emptyCount: Int
	
	init(rating: Float) {
		if rating < 0 {
			self.rating = 0
		} else if rating > 5 {
			self.rating = MAX_RATING
		} else {
			self.rating = rating
		}
		self.fullCount = Int(self.rating)
		self.emptyCount = Int(MAX_RATING - self.rating)
		self.isHalfPresent = Float(fullCount + emptyCount) < MAX_RATING
	}
	
	var body: some View {
		HStack(spacing: 4) {
			ForEach(0..<fullCount, id: \.self) { _ in
				fullStar
			}
			if isHalfPresent {
				emptyStar
			}
			ForEach(0..<emptyCount, id: \.self) { _ in
				emptyStar
			}
		}
	}
	
	private var fullStar: some View {
		Image("star")
			.resizable()
			.frame(width: 11, height: 12)
	}
	
	private var emptyStar: some View {
		Image("star-blank")
			.resizable()
			.frame(width: 11, height: 12)
	}
	
}

struct StarRatingView_Previews: PreviewProvider {
	static var previews: some View {
		StarRatingView(rating: 3)
	}
}

