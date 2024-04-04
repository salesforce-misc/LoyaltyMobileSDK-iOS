//
//  AllBadgesView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI
import LoyaltyMobileSDK

/// Contains all tabs
/// Pull to refresh action passed by BadgeTabContentView is handled here
struct AllBadgesView: View {
	@EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject var badgesVM: BadgesViewModel
	@State var tabSelected: Int = 0
	let columns = [GridItem()]
	let barItems = [BadgeSettings.Text.achievedTabTitle,
					BadgeSettings.Text.availableTabTitle,
					BadgeSettings.Text.expiredTabTitle]
	
	var body: some View {
		ZStack {
			Color.theme.background
			TabView(selection: $tabSelected) {
				achievedView
					.tag(0)
				availableView
					.tag(1)
				expiredView
					.tag(2)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
		}
		.loytaltyNavigationTitle(BadgeSettings.Text.mainTitle)
		.loyaltyNavBarTabBar(TopTabBar(barItems: barItems, tabIndex: $tabSelected))
		.loyaltyNavBarSearchButtonHidden(true)
	}
	
	var achievedView: some View {
		BadgeTabContentView(badges: badgesVM.achievedBadges, 
							error: badgesVM.error,
							emptyTitle: BadgeSettings.Message.achievedTitle,
							emptySubtitle: BadgeSettings.Message.achievedSubtitle
		) {
			reloadBadges()
		}
	}
	
	var availableView: some View {
		BadgeTabContentView(badges: badgesVM.availableBadges, 
							error: badgesVM.error,
							emptyTitle: BadgeSettings.Message.availableTitle,
							emptySubtitle: BadgeSettings.Message.availableSubtitle
		) {
			reloadBadges()
		}
	}
	
	var expiredView: some View {
		BadgeTabContentView(badges: badgesVM.expiredBadges, 
							error: badgesVM.error,
							emptyTitle: BadgeSettings.Message.expiredTitle,
							emptySubtitle: BadgeSettings.Message.expiredSubtitle
		) {
			reloadBadges()
		}
	}
	
	private func reloadBadges() {
		Task {
			Logger.debug("My Badges Screen :- Reloading Badges...")
#if DEBUG
			if UITestingHelper.isUITesting {
				try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
												  reload: true,
												  devMode: true,
												  mockMemberBadgeFileName: UITestingHelper.mockMemberBadgeFileName)
			} else {
				try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
												  reload: true)
			}
#else
			try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
											  reload: true)
#endif
		}
	}
}

#Preview {
	AllBadgesView()
		.environmentObject(DeveloperPreview.instance.rootVM)
		.environmentObject(DeveloperPreview.instance.badgesVM)
}
