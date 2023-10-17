//
//  GameZoneView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/19/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneView: View {
    @State var tabSelected: Int = 0
    @EnvironmentObject var rootVM: AppRootViewModel
    @StateObject var gameViewModel = GameZoneViewModel()
    let barItems = ["Active", "Expired"]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("Game Zone")
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                        .accessibilityIdentifier(AppAccessibilty.GameZone.header)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                TopTabBar(barItems: barItems, tabIndex: $tabSelected)
            }
            ZStack {
                Color.theme.background
                TabView(selection: $tabSelected) {
                    // views
                    activeView
                        .tag(0)
                    expiredView
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }.task {
            await getGames()
        }
        .navigationBarBackButtonHidden()
    }
    
    var activeView: some View {
        GameZoneActiveView(activeGames: gameViewModel.activeGameDefinitions)
    }
    
    var expiredView: some View {
        GameZoneExpiredView(expiredGames: gameViewModel.expiredGameDefinitions)
    }
    
    func getGames() async {
        do {
            try await gameViewModel.fetchGames(memberId: rootVM.member?.membershipNumber ?? "")
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
}

struct GameZoneView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneView()
    }
}
