//
//  GameZoneGridContainerView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneGridContainerView: View {
    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165), spacing: 13), count: 2)

    var games: [GameDefinition]?
    let isExpiredView: Bool
    
    var body: some View {
        ScrollView {
            if games?.isEmpty ?? true {
                EmptyStateView(title: "No Games yet", subTitle: "When you have Games available for Play, you’ll see them here.")
            } else {
                if let games = games, !games.isEmpty {
                    LazyVGrid(columns: gridItems, spacing: 13) {
                        ForEach(Array(games.enumerated()), id: \.offset) { index, gameModel in
                            if isExpiredView {
                                GameZoneExpiredCardView(gameCardModel: gameModel)
                            } else {
                                GameZoneCardView(gameCardModel: gameModel)
									.accessibilityIdentifier("#\(index + 1)_active_game")
                            }
                        }
                    }
					.accessibilityIdentifier("game_grid")
                    .padding(.vertical, 24)
					.padding(.horizontal, 16)
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
