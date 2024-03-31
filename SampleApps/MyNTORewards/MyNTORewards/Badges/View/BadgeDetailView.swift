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
			Image(BadgeSettings.Asset.defaultBadgeImage)
				.resizable()
				.frame(width: BadgeSettings.Dimension.detailBadgeImageWidth,
					   height: BadgeSettings.Dimension.detailBadgeImageHeight)
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
	BadgeDetailView(badge: Badge(id: "id001",
								 name: "NTO Fashionista",
								 description: "Rewarded to members who purchase new products within a month from launch",
								 type: .achieved,
								 endDate: Date(),
								 currentDate: Date().getDate(beforeDays: 3) ?? Date(),
								 imageUrl: nil))
}
