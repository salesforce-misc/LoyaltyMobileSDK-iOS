//
//  GameZoneActiveView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import GamificationMobileSDK_iOS

struct GameZoneActiveView: View {
    var activeGames: [GameDefinition]?

    var body: some View {
        GameZoneGridContainerView(games: activeGames, isExpiredView: false)
    }
}

#Preview {
	GameZoneActiveView()
}
