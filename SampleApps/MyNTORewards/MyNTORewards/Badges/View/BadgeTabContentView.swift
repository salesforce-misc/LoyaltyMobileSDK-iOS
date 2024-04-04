//
//  BadgeTabContentView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/24.
//

import SwiftUI

struct BadgeTabContentView: View {
	let badges: [Badge]
	let error: String?
	let columns = [GridItem()]
	let emptyTitle: String
	let emptySubtitle: String
	let onRefresh: () -> Void
	
    var body: some View {
		ScrollView {
			if self.error != nil {
				ProcessingErrorView(message: BadgeSettings.Message.errorMessage)
					.padding(.top, BadgeSettings.Dimension.errorViewTopPadding)
			} else if badges.isEmpty {
				EmptyStateView(title: emptyTitle, subTitle: emptySubtitle)
			} else {
				LazyVGrid(columns: columns, spacing: 15) {
					ForEach(Array(badges.enumerated()), id: \.offset) { _, badge in
						BadgeCardView(badge: badge)
							.padding(.horizontal, 16)
					}
				}
				.frame(maxWidth: .infinity)
				.padding(.top, 20)
			}
		}
		.refreshable {
			onRefresh()
		}
    }
}

#Preview {
	BadgeTabContentView(badges: [DeveloperPreview.instance.badge],
						error: nil,
						emptyTitle: "No badges yet.",
						emptySubtitle: "When you have badges to claim, you’ll see them here.",
						onRefresh: { print("refreshing") }
	)
}
