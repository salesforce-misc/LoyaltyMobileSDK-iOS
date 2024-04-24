//
//  BadgeDetailView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 25/03/24.
//

import SwiftUI

struct BadgeDetailView: View {
	@Environment(\.dismiss) var dismiss
	let badge: Badge
	var body: some View {
		VStack {
			header
			HStack {
				VStack(alignment: .leading, spacing: 16) {
					Text(badge.name)
						.font(.badgeCardDetailTitleLabel)
						.foregroundColor(BadgeSettings.Colors.badgeDetailTitleColor)
					expiryText
					description
				}
				.foregroundColor(BadgeSettings.Colors.badgeDetailTextColor)
				.padding()
				Spacer()
			}
			Spacer()
			Button(BadgeSettings.Text.detailCloseButtonTitle) {
				dismiss()
			}
			.accessibilityIdentifier(BadgeSettings.Accessibilty.closeButton)
			.buttonStyle(DarkShortButton())
		}
	}
	
	var header: some View {
		ZStack {
			Rectangle()
				.frame(height: BadgeSettings.Dimension.detailBackgroundRectangleHeight)
				.foregroundColor(badge.type == .expired ? BadgeSettings.Colors.expiredBadgeDetailBackgroundColor : BadgeSettings.Colors.badgeDetailBackgroundColor)
				.overlay(alignment: .topTrailing, content: { closeIcon })
			Group {
				if badge.type == .available {
					Image(BadgeSettings.Asset.availableBadgeImage)
						.resizable()
				} else if let imageUrl = badge.imageUrl {
					LoyaltyAsyncImage(url: imageUrl, content: { image in
						image
							.resizable()
							.scaledToFill()
					}, placeholder: {
						ProgressView()
					})
				} else {
					Image(BadgeSettings.Asset.defaultBadgeImage)
						.resizable()
				}
			}
			.frame(width: BadgeSettings.Dimension.detailBadgeImageWidth,
					height: BadgeSettings.Dimension.detailBadgeImageHeight)
			.opacity(badge.type == .expired ? 0.25 : 1)
			.overlay {
				if badge.type == .expired {
					Image(BadgeSettings.Asset.expiredTimerIcon)
						.resizable()
						.frame(width: BadgeSettings.Dimension.detailBadgeExpiredTimerIconWidth,
							   height: BadgeSettings.Dimension.detailBadgeExpiredTimerIconHeight)
				}
			}
		}
	}
	
	@ViewBuilder
	var expiryText: some View {
		switch badge.type {
		case .achieved:
			if let endDateString = badge.endDateString {
				HStack(spacing: 4) {
					Text(BadgeSettings.Text.detailExpiringOn)
						.font(.badgeCardDetailExpiryLabel)
					Text(endDateString)
						.font(.badgeCardDetailExpiryDateLabel)
				}
			}
		case .available:
			Text(BadgeSettings.Text.notAchievedYet)
				.font(.badgeCardDetailExpiryLabel)
		case .expired:
			if let endDateString = badge.endDateString {
				HStack(spacing: 4) {
					Text(BadgeSettings.Text.detailExpiredOn)
						.font(.badgeCardDetailExpiryLabel)
					Text(endDateString)
						.font(.badgeCardDetailExpiryDateLabel)
				}
			}
		}
	}
	
	var description: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(BadgeSettings.Text.detailDescriptionTitle)
				.font(.badgeCardTitleLabel)
			Text(badge.description)
				.font(.badgeCardDescriptionLabel)
				.lineSpacing(2)
		}
	}
	
	var closeIcon: some View {
		Image(BadgeSettings.Asset.closeIcon)
			.padding()
			.onTapGesture {
				dismiss()
			}
	}
}

#Preview {
	BadgeDetailView(badge: DeveloperPreview.instance.badge)
}
