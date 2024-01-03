//
//  GameZoneExpiredView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import GamificationMobileSDK

struct GameZoneExpiredView: View {
    var expiredGames: [GameDefinition]?

    var body: some View {
        VStack(alignment: .leading) {
            Text(StringConstants.Gamification.expiredTabHeaderLabel)
                .font(Font.scratchText)
                .foregroundColor(Color.theme.superLightText)
                .padding([.horizontal, .top], 16)
			GameZoneGridContainerView(games: expiredGames, 
                                      cardType: .expired,
									  emptyViewSubtitle: StringConstants.Gamification.emptySubtitleForExpiredView)
        }
    }
}

#Preview {
	GameZoneExpiredView()
}
