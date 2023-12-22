//
//  GameZoneGridContainerView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK
enum GameCardType {
    case active
    case played
    case expired
}

struct GameZoneGridContainerView: View {
    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165), spacing: 13), count: 2)

    var games: [GameDefinition]?
    let cardType: GameCardType?
    
    var body: some View {
        ScrollView {
            if games?.isEmpty ?? true {
                EmptyStateView(title: "No Games yet", subTitle: "When you have Games available for Play, you’ll see them here.")
            } else {
                if let games = games, !games.isEmpty {
                    LazyVGrid(columns: gridItems, spacing: 13) {
                        ForEach(Array(games.enumerated()), id: \.offset) { index, gameModel in
                            switch cardType {
                            case .active:
                                GameZoneCardView(gameCardModel: gameModel)
                                    .accessibilityIdentifier("#\(index + 1)_active_game")
                            case .played:
                                GameZonePlayedCardView(gameCardModel: gameModel)
                            case .expired:
                                GameZoneExpiredCardView(gameCardModel: gameModel)
                            case .none:
                                EmptyView()
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
    GameZoneGridContainerView(cardType: .active)
}
