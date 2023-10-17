//
//  GameZoneExpiredView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneExpiredView: View {
    var gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165)), count: 2)
    var games: [GameDefinition]?

    var body: some View {
        ScrollView {
            if games?.isEmpty ?? true {
                EmptyStateView(title: "No Games yet", subTitle: "When you have Games available for Play, you’ll see them here.")
            } else {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(games!, id: \.definitionId) { game in
                        if game.type == .scratchCard {
                            ScrathCardCardView()
                        } else {
                            FortuneWheelCardView()
                        }
                    }
                }
                .padding([.vertical], 24)
            }
        }
    }
}

struct GameZoneInActiveView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneExpiredView()
    }
}
