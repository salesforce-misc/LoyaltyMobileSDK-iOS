//
//  PlayGameViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 21/11/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class PlayGameViewModel: ObservableObject {
    @Published private(set) var state = LoadingState.idle
    @Published var playedGameRewards: [PlayGameReward]?
    @Published var issuedRewardId: String?

    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.shared.getInstanceURL(),
                                              forceClient: ForceClient(auth: authManager))
    }
    
    func playGame(gameParticipantRewardId: String) async {
        state = .loading
        do {
			try await Task.sleep(nanoseconds: 3_000_000_000)
            try await getPlayedGameRewards(gameParticipantRewardId: gameParticipantRewardId, devMode: true)
            self.state = .loaded
        } catch {
            self.state = .failed(error)
            Logger.error(error.localizedDescription)
        }
    }
    
    func getPlayedGameRewards(gameParticipantRewardId: String, devMode: Bool = false) async throws {
        do {
            let result = try await loyaltyAPIManager.playGame(gameParticipantRewardId: gameParticipantRewardId, devMode: devMode)
            issuedRewardId = result.gameReward.first?.issuedRewardReference
			self.playedGameRewards = result.gameReward
        } catch {
            self.state = .failed(error)
            throw error
        }
    }
    
    func clear() {
        playedGameRewards = nil
    }
}
