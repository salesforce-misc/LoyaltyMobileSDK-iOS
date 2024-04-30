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
	
	var body: some View {
		VStack {
			Spacer()
			badgeImage
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
	
	@ViewBuilder
	var badgeImage: some View {
		Group {
			if let imageUrl = badge.imageUrl {
				LoyaltyAsyncImage(url: imageUrl, content: { image in
					image
						.resizable()
						.scaledToFill()
				}, placeholder: {
					ProgressView()
				}, defaultImage: UIImage(named: BadgeSettings.Asset.defaultBadgeImage))
			} else {
				Image(BadgeSettings.Asset.defaultBadgeImage)
					.resizable()
			}
		}.frame(width: BadgeSettings.Dimension.previewBadgeImageWidth,
				height: BadgeSettings.Dimension.previewBadgeImageHeight)
	}
}

#Preview {
	BadgePreviewCardView(badge: DeveloperPreview.instance.badge)
}
