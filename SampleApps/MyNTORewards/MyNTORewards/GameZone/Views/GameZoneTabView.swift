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
            VStack {
                Spacer()
                ProcessingErrorView(message: "Oops! Something went wrong while processing the request. Try again.")
                Spacer()
                Button {
                    Logger.debug("get games Error \(error.localizedDescription)")
                    getGames()
                } label: {
                    Text(StringConstants.Receipts.tryAgainButton)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .longFlexibleButtonStyle()
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
                Logger.debug("Reloading available Games...")
                do {
                    try await gameViewModel.reload(id: rootVM.member?.loyaltyProgramMemberId ?? "", number: "")
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
        GameZonePlayedView(playedGames: gameViewModel.playedGameDefinitions)
    }
    
    var expiredView: some View {
        GameZoneExpiredView(expiredGames: gameViewModel.expiredGameDefinitions)
    }
    
    func getGames() {
        Task {
            do {
                try await gameViewModel.getGames(participantId: rootVM.member?.loyaltyProgramMemberId ?? "")
                
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
