//
//  BadgePreviewCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct BadgePreviewCardView: View {
	@EnvironmentObject private var badgesVM: BadgesViewModel
	@State var showDetail = false
	let badge: Badge
	// swiftlint:disable line_length
	let imageUrl = "https://images.unsplash.com/photo-1521249635712-69ca33adf729?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
	// swiftlint:enable line_length
	
	var body: some View {
		VStack {
			Spacer()
			/*
			LoyaltyAsyncImage(url: imageUrl, content: { image in
				image
					.resizable()
					.scaledToFill()
			}, placeholder: {
				ProgressView()
			})
			.accessibilityIdentifier("ToDo") //TODO: Add accessibility identifier
			.frame(width: 165, height: 92)
			.cornerRadius(5, corners: [.topLeft, .topRight])
			 */
			Image(BadgeSettings.Asset.defaultBadgeImage)
			Spacer()
			Text(badge.name)
				.frame(width: 72)
				.font(.badgeLabel)
				.multilineTextAlignment(.center)
				.frame(width: BadgeSettings.Dimension.previewCardWidth, height: 41)
				.background(Color.theme.badgeBackground)
			
		}
		.contentShape(Rectangle())
		.onTapGesture {
			showDetail.toggle()
		}
		.sheet(isPresented: $showDetail, content: {
			BadgeDetailView(badge: badge)
				.presentationDetents([.medium])
		})
		.frame(width: BadgeSettings.Dimension.previewCardWidth,
			   height: BadgeSettings.Dimension.previewCardHeight)
		.background(Color.white)
		.cornerRadius(BadgeSettings.Dimension.previewCardCornerRadius)
		.shadow(
			color: Color.gray.opacity(0.2),
			radius: BadgeSettings.Dimension.previewCardCornerRadius,
			x: 0,
			y: 0
		)
	}
}

struct BadgePreviewCardView_Previews: PreviewProvider {
    static var previews: some View {
		BadgePreviewCardView(badge: Badge(id: "id001",
										  name: "NTO Fashionista",
										  description: "Rewarded to members who purchase new products within a month from launch",
										  type: .achieved,
										  endDate: Date(),
										  currentDate: Date().getDate(beforeDays: 3) ?? Date(),
										  imageUrl: nil) )
    }
}
