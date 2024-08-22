//
//  GameZoneTabView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import GamificationMobileSDK

struct GameZoneTabView: View {
    @Binding var tabSelected: Int
    @EnvironmentObject var rootVM: AppRootViewModel
    @EnvironmentObject var gameViewModel: GameZoneViewModel
    
    var body: some View {
        switch gameViewModel.state {
        case .idle:
            Color.theme.background
        case .loading:
            ProgressView()
        case .failed:
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack {
                        ProcessingErrorView(message: "Oops! Something went wrong while processing the request. Try again.")
                            .frame(maxWidth: 500)
                    }
                    .padding()
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }.refreshable {
                    await refreshGames()
                }
            }
        case .loaded:
            TabView(selection: $tabSelected) {
                // views
                activeView
                    .tag(0)
                playedView
                    .tag(1)
                expiredView
                    .tag(2)

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .refreshable {
                await refreshGames()
            }
        }
    }
    
    var activeView: some View {
        GameZoneActiveView(activeGames: gameViewModel.activeGameDefinitions)
    }
    
    var playedView: some View {
        GameZonePlayedView(playedGames: gameViewModel.playedGameDefinitions)
    }
    
    var expiredView: some View {
        GameZoneExpiredView(expiredGames: gameViewModel.expiredGameDefinitions)
    }
    
    func refreshGames() async {
           GamificationLogger.debug("Reloading available Games...")
            do {
                try await gameViewModel.reload(id: rootVM.member?.loyaltyProgramMemberId ?? "", number: "")
                GamificationLogger.debug("loaded available Games...")
                
            } catch {
                GamificationLogger.error("Reload Available Games Error: \(error)")
            }
    }
    
    func getGames() {
        Task {
            do {
                try await gameViewModel.getGames(participantId: rootVM.member?.loyaltyProgramMemberId ?? "")
                
            } catch {
                GamificationLogger.error(error.localizedDescription)
            }
        }
    }
}

#Preview {
    GameZoneTabView(tabSelected: .constant(0))
        .environmentObject(AppRootViewModel())
        .environmentObject(GameZoneViewModel())
}
