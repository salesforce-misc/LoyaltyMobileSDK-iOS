//
//  GameZoneActiveView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneActiveView: View {
    var gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165)), count: 2)
    var activeGames: [GameDefinition]?

    var body: some View {
        ScrollView {
            if activeGames?.isEmpty ?? true {
                EmptyStateView(title: "No Games yet", subTitle: "When you have Games available for Play, you’ll see them here.")
            } else {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(activeGames!, id: \.definitionId) { game in
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

struct GameZoneActiveView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneActiveView()
    }
}
