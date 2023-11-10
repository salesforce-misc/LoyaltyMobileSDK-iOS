//
//  GameZoneGridContainerView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneGridContainerView: View {
    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165)), count: 2)
    var games: [GameDefinition]?
    let isExpiredView: Bool
    
    var body: some View {
        ScrollView {
            if games?.isEmpty ?? true {
                EmptyStateView(title: "No Games yet", subTitle: "When you have Games available for Play, you’ll see them here.")
            } else {
                if let games = games, !games.isEmpty {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(games, id: \.definitionID) { gameModel in
                            if isExpiredView {
                                GameZoneExpiredCardView(gameCardModel: gameModel)
                            } else {
                                GameZoneCardView(gameCardModel: gameModel)
                            }
                        }
                    }
                    .padding([.vertical], 24)
                } else {
                    EmptyStateView(title: "No Games yet")
                }
            }
        }
    }
}

#Preview {
    GameZoneGridContainerView(isExpiredView: false)
}
