//
//  BadgeCardView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 22/03/24.
//

import SwiftUI
import LoyaltyMobileSDK

struct BadgeCardView: View {
	let badge: Badge
	
    var body: some View {
		HStack(spacing: 16) {
			badgeImage
			Group {
				VStack(alignment: .leading, spacing: 8) {
					title
					description
				}
				expiryText
			}
			.font(.badgeCardDescriptionLabel)
		}
		.padding(.leading, 21)
		.padding(.trailing, 13)
		.padding(.vertical, 16)
		.background(.white)
		.cornerRadius(10)
		.frame(maxWidth: .infinity)
    }
	
	@ViewBuilder
	var badgeImage: some View {
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
				}, defaultImage: UIImage(named: BadgeSettings.Asset.defaultBadgeImage))
			} else {
				Image(BadgeSettings.Asset.defaultBadgeImage)
					.resizable()
			}

		}
		.scaledToFit()
		.frame(width: BadgeSettings.Dimension.imageWidth,
				height: BadgeSettings.Dimension.imageHeight)
		.opacity(badge.type == .expired ? 0.25 : 1)
		.overlay {
			if badge.type == .expired {
				Image(BadgeSettings.Asset.expiredTimerIcon)
					.resizable()
					.frame(width: BadgeSettings.Dimension.expiredTimerIconWidth,
						   height: BadgeSettings.Dimension.expiredTimerIconHeight)
			}
		}
	}
	
	var title: some View {
		HStack {
			Text(badge.name)
				.font(.badgeCardTitleLabel)
				.lineLimit(1)
			Spacer()
		}
	}
	
	var description: some View {
		Text(badge.description)
			.font(.badgeCardDescriptionLabel)
			.lineSpacing(4)
			.frame(width: 178, alignment: .topLeading)
			.foregroundStyle(Color.theme.textInactive)
	}
	
	@ViewBuilder
	var expiryText: some View {
		if badge.type != .available,
		   let daysToExpire = badge.daysToExpire {
			VStack {
				Spacer()
				if badge.type == .achieved {
					if daysToExpire < 0 {
						getExpiredText(for: abs(daysToExpire))
					} else {
						getExpiringText(for: abs(daysToExpire))
					}
				} else if badge.type == .expired {
					getExpiredText(for: abs(daysToExpire))
				}
			}
			.frame(width: BadgeSettings.Dimension.expiryTextWidth)
			.multilineTextAlignment(.trailing)
			.lineSpacing(2)
			.foregroundStyle(Color.theme.textInactive)
		}
	}
	
	func getExpiredText(for days: Int) -> some View {
		VStack(alignment: .trailing, spacing: 2) {
			Text("Badge expired")
			Text(getGrammaticNumber(for: days))
				.font(.badgeCardExpiryDaysLabel)
			Text("ago")
		}
		.frame(maxWidth: .infinity)
		.font(.badgeCardExpiryLabel)
	}
	
	func getExpiringText(for days: Int) -> some View {
		HStack {
			Spacer()
			VStack(alignment: .trailing, spacing: 2) {
				Text("Badge expires\(days == 0 ? "" : " in")")
					.font(.badgeCardExpiryLabel)
				Text(getGrammaticNumber(for: days))
					.font(.badgeCardExpiryDaysLabel)
			}
		}
		.frame(maxWidth: .infinity)
	}
	
	func getGrammaticNumber(for numberOfDays: Int) -> String {
		switch numberOfDays {
		case 0:
			return "today"
		case 1:
			return "\(numberOfDays) day"
		default:
			return "\(numberOfDays) days"
		}
	}
}

#Preview {
	BadgeCardView(badge: DeveloperPreview.instance.badge)
}
