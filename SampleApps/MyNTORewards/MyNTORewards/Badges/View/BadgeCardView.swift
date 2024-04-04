//
//  BadgeCardView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 22/03/24.
//

import SwiftUI

struct BadgeCardView: View {
	@State var showDetail = false
	let badge: Badge
	
    var body: some View {
		HStack(spacing: 16) {
			Image(BadgeSettings.Asset.defaultBadgeImage)
				.resizable()
				.frame(width: BadgeSettings.Dimension.cardWidth,
					   height: BadgeSettings.Dimension.cardHeight
				)
			Group {
				VStack(alignment: .leading, spacing: 8) {
					title
					description
				}
				expiryText
			}
			.font(.badgeCardDescriptionLabel)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			showDetail.toggle()
		}
		.sheet(isPresented: $showDetail, content: {
			BadgeDetailView(badge: badge)
				.presentationDetents([.medium])
		})
		.padding(.leading, 21)
		.padding(.trailing, 13)
		.padding(.vertical, 16)
		.background(.white)
		.cornerRadius(10)
		.frame(maxWidth: .infinity)
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
					getExpiringText(for: abs(daysToExpire))
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
