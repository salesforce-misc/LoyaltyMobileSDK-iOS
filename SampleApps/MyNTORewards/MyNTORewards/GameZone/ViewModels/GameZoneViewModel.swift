//
//  GameZoneViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import Foundation
import LoyaltyMobileSDK
import GamificationMobileSDK_iOS

enum LoadingState: ReflectiveEquatable {
	case idle
	case loading
	case failed(Error)
	case loaded
}

@MainActor
class GameZoneViewModel: ObservableObject, Reloadable {
    @Published private(set) var state = LoadingState.idle
    @Published var playedGameDefinitions: [GameDefinition]?
    @Published var activeGameDefinitions: [GameDefinition]?
    @Published var expiredGameDefinitions: [GameDefinition]?
    
    private let authManager: GamificationForceAuthenticator
    private var loyaltyAPIManager: APIManager
	private var devMode: Bool
    private var mockFileName: String
    
    init(
        authManager: GamificationForceAuthenticator = GamificationForceAuthManager.shared,
        devMode: Bool = false,
        mockFileName: String = "GetGames_Success") {
            self.mockFileName = mockFileName
            self.devMode = devMode
            self.authManager = authManager
            loyaltyAPIManager = APIManager(auth: authManager,
                                           instanceURL: AppSettings.shared.getInstanceURL(),
                                           forceClient: GamificationForceClient(auth: authManager))
        }
    
    func getGames(participantId: String, reload: Bool = false) async throws {
        state = .loading
        do {
            try await fetchGames(participantId: participantId)
            self.state = .loaded
        } catch {
            self.state = .failed(error)
            throw error
        }
    }
    
    func fetchGames(participantId: String) async throws {
        do {
            let result = try await loyaltyAPIManager.getGames(participantId: participantId,
															  devMode: devMode)
            activeGameDefinitions = result.gameDefinitions.filter({ gameDefinition in
                if let expirationDate = gameDefinition.participantGameRewards.first?.expirationDate {
                    return expirationDate >= Date() && gameDefinition.participantGameRewards.first?.status == .yetToReward
                } else {
                    return gameDefinition.participantGameRewards.first?.status == .yetToReward
                }
            })
            playedGameDefinitions = result.gameDefinitions.filter({$0.participantGameRewards.first?.status == .rewarded})
            expiredGameDefinitions = result.gameDefinitions.filter({ gameDefinition in
                guard let expirationDate = gameDefinition.participantGameRewards.first?.expirationDate else { return false }
                return expirationDate < Date()
            })
        } catch {
            self.state = .failed(error)
            throw error
        }
    }
    
    func clear() {
        activeGameDefinitions = nil
        playedGameDefinitions = nil
        expiredGameDefinitions = nil
    }
    
    func reload(id: String, number: String) async throws {
        try await fetchGames(participantId: id)
    }
}
