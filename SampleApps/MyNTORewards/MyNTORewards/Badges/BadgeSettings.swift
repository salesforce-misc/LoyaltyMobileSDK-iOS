//
//  BadgeSettings.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 29/03/24.
//

import Foundation
import SwiftUI

struct BadgeSettings {
	struct Dimension {
		// Preview
		static let previewSectionHeight: CGFloat = 200
		static let previewErrorHeight: CGFloat = 180
		static let previewErrorYOffset: CGFloat = -50
		static let previewCardHeight: CGFloat = 126
		static let previewCardWidth: CGFloat = 106
		static let previewCardCornerRadius: CGFloat = 10
		static let messageImageHeight: CGFloat = 82
		static let messageImageWidth: CGFloat = 82
		static let previewBadgeImageWidth: CGFloat = 40
		static let previewBadgeImageHeight: CGFloat = 48
		
		// BadgeDetailView
		static let detailBackgroundRectangleHeight: CGFloat = 180
		static let detailBadgeImageHeight: CGFloat = 134
		static let detailBadgeImageWidth: CGFloat = 134
		
		static let detailBadgeExpiredTimerIconHeight: CGFloat = 48
		static let detailBadgeExpiredTimerIconWidth: CGFloat = 48
		
		// BadgeCardView
		static let expiryTextWidth: CGFloat = 52
		static let imageWidth: CGFloat = 64
		static let imageHeight: CGFloat = 64
		
		static let expiredTimerIconHeight: CGFloat = 24
		static let expiredTimerIconWidth: CGFloat = 24
		
		// Error
		static let errorViewTopPadding: CGFloat = 100
	}
	
	struct Message {
		// Achieved
		static let achievedTitle = "No badges earned"
		static let achievedSubtitle = "After you earn a badge, you’ll find it here."
		
		// Available
		static let availableTitle = "No badges to earn yet"
		static let availableSubtitle = "Watch this space for badges that are made available to earn."
		
		// Expired
		static let expiredTitle = "No expired badges"
		static let expiredSubtitle = "When your badges expire, you’ll find them here."
		
		static let errorMessage = "We couldn’t get your badges."
	}
	
	struct Asset {
		static let defaultBadgeImage = "img-badge"
		static let availableBadgeImage = "img-available-badge"
		static let closeIcon = "ic-close"
		static let expiredTimerIcon = "ic-expired-timer"
	}
	
	struct Colors {
		static let expiredBadgeDetailBackgroundColor = Color("ExpiredBadgeDetailBackground") // #EAEAEA
		static let badgeDetailBackgroundColor = Color("BadgeBackground") // #E0E0E0
		static let badgeDetailTextColor = Color("BadgeDetailTextColor") // #444
		static let badgeDetailTitleColor = Color("BadgeDetailTitleColor") // #181818
	}
	
	struct Text {
		static let mainTitle = "My Badges"
		static let detailCloseButtonTitle = "Close"
		static let detailDescriptionTitle = "Learn More"
		static let notAchievedYet = "Not achieved yet."
		static let detailExpiringOn = "Badge expires on"
		static let detailExpiredOn = "Badge expired on"
		static let achievedTabTitle = "Achieved"
		static let availableTabTitle = "Available"
		static let expiredTabTitle = "Expired"
	}
	
	struct CacheFolders {
		static let programBadges = "LoyaltyProgramBadges"
		static let memberBadges = "LoyaltyProgramMemberBadges"
	}
	
	struct Accessibilty {
		static let closeButton = "close_button"
	}
}

extension Font {
	static var badgeLabel: Font {
		return Font.custom("SFPro-Display", size: 12)
	}
	
	static var badgeCardDescriptionLabel: Font {
		return Font.custom("SFPro-Display", size: 13)
	}
	
	static var badgeCardTitleLabel: Font {
		return Font.custom("SFPro-bold", size: 13)
	}
	
	static var badgeCardExpiryLabel: Font {
		return Font.custom("SFPro-Display", size: 8)
	}
	
	static var badgeCardExpiryDaysLabel: Font {
		return Font.custom("SFPro-bold", size: 8)
	}
	
	static var badgeCardDetailTitleLabel: Font {
		return Font.custom("SFPro-bold", size: 24)
	}
	
	static var badgeCardDetailExpiryLabel: Font {
		return Font.custom("SFPro-Display", size: 14)
	}
	
	static var badgeCardDetailExpiryDateLabel: Font {
		return Font.custom("SFPro-bold", size: 14)
	}
	
	static var badgeCardDetailDescriptionLabel: Font {
		return Font.custom("SFPro-bold", size: 24)
	}
}
