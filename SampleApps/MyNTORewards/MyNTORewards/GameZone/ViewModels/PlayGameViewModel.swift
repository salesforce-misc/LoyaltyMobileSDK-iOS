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
    
	var wheelColors: [Color]?
    private let authManager: GamificationForceAuthenticator
    private var gamificationAPIManager: APIManager
    private var devMode: Bool
    let mockFileName: String

    init(
        authManager: GamificationForceAuthenticator = GamificationForceAuthManager.shared,
        devMode: Bool = false,
        mockFileName: String = "PlayGame_Success") {
            self.mockFileName = mockFileName
            self.devMode = devMode
            self.authManager = authManager
            gamificationAPIManager = APIManager(auth: authManager,
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
            let result = try await gamificationAPIManager.playGame(gameParticipantRewardId: gameParticipantRewardId, 
																   devMode: devMode,
																   mockFileName: mockFileName)
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
        if let colors: [Color] = gameModel?.gameRewards.map({(Color(hex: ($0.color ?? "#2636E3")))}) {
            wheelColors = colors
            return wheelColors
        }
        return nil
    }
        
    func clear() {
        playedGameRewards = nil
    }
}
