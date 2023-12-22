//
//  GameZoneView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/19/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneView: View {
    @State var tabSelected: Int = 0
    let barItems = [StringConstants.Gamification.activeTab, StringConstants.Gamification.playedTab, StringConstants.Gamification.expiredTab]
	@EnvironmentObject var gameViewModel: GameZoneViewModel
	@EnvironmentObject var rootVM: AppRootViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text(StringConstants.Gamification.gameZoneHeader)
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                        .accessibilityIdentifier(AppAccessibilty.GameZone.header)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                TopTabBar(barItems: barItems, tabIndex: $tabSelected)
            }
            ZStack {
                Color.theme.background
                GameZoneTabView(tabSelected: $tabSelected)
            }
        }.navigationBarHidden(true)
			.onWillAppear {
				getGames()
			}
    }
	
	func getGames() {
		Task {
			do {
				try await gameViewModel.getGames(participantId: rootVM.member?.loyaltyProgramMemberId ?? "")
				
			} catch {
				Logger.error(error.localizedDescription)
			}
		}
	}
}

#Preview {
	GameZoneView()
		.environmentObject(DeveloperPreview.instance.rootVM)
		.environmentObject(GameZoneViewModel())
}
