//
//  GameZonePlayedView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 22/12/23.
//

import SwiftUI
import GamificationMobileSDK

struct GameZonePlayedView: View {
    var playedGames: [GameDefinition]?

    var body: some View {
        VStack(alignment: .leading) {
			/* Do not show until API gives played date */
			/* HStack {
				Text(StringConstants.Gamification.playedTabHeaderLabel)
					.font(Font.scratchText)
					.foregroundColor(Color.theme.superLightText)
				.padding([.horizontal, .top], 16)
				Spacer()
			} */
            GameZoneGridContainerView(games: playedGames, cardType: .played, emptyViewSubtitle: StringConstants.Gamification.emptySubtitleForPlayedView)
        }
    }
}

#Preview {
    GameZonePlayedView()
}
