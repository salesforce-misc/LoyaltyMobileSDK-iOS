//
//  GameZoneActiveView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneActiveView: View {
    var activeGames: [GameDefinition]?

    var body: some View {
        GameZoneGridContainerView(games: activeGames, isExpired: false)
    }
}

struct GameZoneActiveView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneActiveView()
    }
}
