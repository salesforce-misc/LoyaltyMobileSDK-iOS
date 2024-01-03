//
//  PlayGameViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 21/11/23.
//

import Foundation
import GamificationMobileSDK
import SwiftUI

@MainActor
class PlayGameViewModel: ObservableObject {
    @Published private(set) var state = LoadingState.idle
    @Published var playedGameRewards: [PlayGameReward]?
    @Published var issuedRewardId: String?
    let defaultColors: [String] = ["01CD6C", "#0099DD", "#FF4B3A", "#0099DD", "#0099DD", "#FF4B3A", "01CD6C", "#0099DD", "#FF4B3A", "#FFC501" ]
    var wheelColors: [Color]?

    private let authManager: GamificationForceAuthenticator
    private var loyaltyAPIManager: APIManager
    private var devMode: Bool
    let mockFileName: String

    init(
        authManager: GamificationForceAuthenticator = GamificationForceAuthManager.shared,
        devMode: Bool = false,
        mockFileName: String = "PlayGame_Success") {
            self.mockFileName = mockFileName
            self.devMode = devMode
            self.authManager = authManager
            loyaltyAPIManager = APIManager(auth: authManager,
                                           instanceURL: AppSettings.shared.getInstanceURL(),
                                           forceClient: GamificationForceClient(auth: authManager))
        }
    
    func playGame(gameParticipantRewardId: String) async {
        state = .loading
        do {
            try await getPlayedGameRewards(gameParticipantRewardId: gameParticipantRewardId)
            self.state = .loaded
        } catch {
            self.state = .failed(error)
        }
    }
    
    func getPlayedGameRewards(gameParticipantRewardId: String) async throws {
        do {
            let result = try await loyaltyAPIManager.playGame(gameParticipantRewardId: gameParticipantRewardId, devMode: devMode)
            issuedRewardId = result.gameReward.first?.gameRewardId
            self.playedGameRewards = result.gameReward
        } catch {
            self.state = .failed(error)
            throw error
        }
    }
    
    func getWheelColors(gameModel: GameDefinition?) -> [Color]? {
        if let wheelColors = wheelColors {
            return wheelColors
        }
        if let colors: [Color] = gameModel?.gameRewards.map({(Color(hex: ($0.color ?? "#FFFFFF")))}) {
            wheelColors = colors
            return wheelColors
        }
        return nil
    }
        
    func clear() {
        playedGameRewards = nil
    }
}
