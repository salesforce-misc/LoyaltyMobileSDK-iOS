//
//  GameZoneExpiredView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneExpiredView: View {
    var expiredGames: [GameDefinition]?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Expired in the last 90 Days")
                .font(Font.scratchText)
                .foregroundColor(Color.theme.superLightText)
                .padding([.horizontal, .top], 16)
            GameZoneGridContainerView(games: expiredGames, isExpired: true)
        }
    }
}

struct GameZoneInActiveView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneExpiredView()
    }
}
