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
    @ObservedObject var gameViewModel = GameZoneViewModel()
    let barItems = ["Active", "Expired"]
    
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
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    var activeView: some View {
        GameZoneActiveView(activeGames: gameViewModel.activeGameDefinitions)
    }
    
    var expiredView: some View {
        GameZoneExpiredView(expiredGames: gameViewModel.expiredGameDefinitions)
    }
    
    func getGames() {
        Task {
            do {
                try await gameViewModel.getGames(memberId: rootVM.member?.membershipNumber ?? "")
                
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

//#Preview {
//    GameZoneTabView(tabSelected: 0)
//}
