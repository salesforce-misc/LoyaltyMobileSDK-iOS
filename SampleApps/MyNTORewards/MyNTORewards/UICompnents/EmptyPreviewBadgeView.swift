//
//  EmptyPreviewBadgeView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/24.
//

import SwiftUI

struct EmptyPreviewBadgeView: View {
	let title: String
	let subTitle: String?
	
	init(title: String, subTitle: String? = nil) {
		self.title = title
		self.subTitle = subTitle
	}
	
	var body: some View {
		VStack(spacing: 8) {
			Image("img-empty-state")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 200, height: 100)
			
			VStack(spacing: 8) {
				Text(title)
					.accessibility(identifier: title)
					.font(.emptyStateTitle)
				if let subTitle = subTitle {
					Text(subTitle)
						.font(.emptyStateSubTitle)
						.multilineTextAlignment(.center)
						.lineSpacing(6)
						.padding(.horizontal, 45)
						.accessibilityIdentifier(subTitle)
				}
			}
		}
	}
}

#Preview {
	EmptyPreviewBadgeView(title: "No items yet")
}
