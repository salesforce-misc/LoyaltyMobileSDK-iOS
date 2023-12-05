//
//  GameZoneTabView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneTabView: View {
    @Binding var tabSelected: Int
    @EnvironmentObject var rootVM: AppRootViewModel
    @EnvironmentObject var gameViewModel: GameZoneViewModel
    
    var body: some View {
        switch gameViewModel.state {
        case .idle:
            Color.theme.background.onAppear(perform: getGames)
        case .loading:
            ProgressView()
        case .failed(let error):
            // To Do Need to Design Error View
            Text(error.localizedDescription)
                .font(.congratsTitle)
                .padding(.horizontal, 15)
        case .loaded:
            TabView(selection: $tabSelected) {
                // views
                activeView
                    .tag(0)
                expiredView
                    .tag(1)
                playedView
                    .tag(2)

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .refreshable {
                Logger.debug("Reloading available Games...")
                do {
                    try await gameViewModel.reload(id: "0lMSB00000001wz2AA", number: "")
                    Logger.debug("loaded available Games...")
                    
                } catch {
                    Logger.error("Reload Available Games Error: \(error)")
                }
            }
        }
    }
    
    var activeView: some View {
        GameZoneActiveView(activeGames: gameViewModel.activeGameDefinitions)
    }
    
    var playedView: some View {
        GameZoneActiveView(activeGames: gameViewModel.playedGameDefinitions)
    }
    
    var expiredView: some View {
        GameZoneExpiredView(expiredGames: gameViewModel.expiredGameDefinitions)
    }
    
    func getGames() {
        Task {
            do {
                try await gameViewModel.getGames(participantId: rootVM.member?.membershipNumber ?? "")
                
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

#Preview {
    GameZoneTabView(tabSelected: .constant(0))
        .environmentObject(AppRootViewModel())
        .environmentObject(GameZoneViewModel())
}
