//
//  BadgesView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct BadgesView: View {
	@EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject var badgesVM: BadgesViewModel
	
	var body: some View {
		
		ViewAllView(title: BadgeSettings.Text.mainTitle) {
			AllBadgesView()
		} content: {
			if badgesVM.error != nil {
				PreviewErrorView(message: BadgeSettings.Message.errorMessage)
			} else if badgesVM.previewBadges.isEmpty {
				PreviewEmptyView(message: BadgeSettings.Message.achievedSubtitle)
					.task {
						await fetchBadges()
					}
			} else {
				HStack(spacing: 16) {
					ForEach(Array(badgesVM.previewBadges.enumerated()), id: \.offset) { _, badge in
						BadgePreviewCardView(badge: badge)
					}
					if badgesVM.previewBadges.count < 3 {
						Spacer()
					}
				}
				.padding(.horizontal, 16)
				Spacer()
			}
		}
		.frame(height: BadgeSettings.Dimension.previewSectionHeight)
	}
	
	private func fetchBadges() async {
		do {
			Logger.debug("Profile Screen -> BadgesView :- Fetching Badges...")
#if DEBUG
			if UITestingHelper.isUITesting {
				try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
												  devMode: true,
												  mockMemberBadgeFileName: UITestingHelper.mockMemberBadgeFileName)
			} else {
				try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "")
			}
#else
			try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "")
#endif
			
		} catch {
			Logger.error("Profile Screen -> BadgesView :- Load Badges Error: \(error)")
		}
	}
}

#Preview {
	BadgesView()
		.environmentObject(DeveloperPreview.instance.rootVM)
		.environmentObject(DeveloperPreview.instance.badgesVM)
}
