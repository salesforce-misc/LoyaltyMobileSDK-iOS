//
//  GameZoneViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import Foundation
import LoyaltyMobileSDK

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
    
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
	private var devMode: Bool
	private var mockFileName: String
    
	init(
		authManager: ForceAuthenticator = ForceAuthManager.shared,
		localFileManager: FileManagerProtocol = LocalFileManager.instance,
		devMode: Bool = false,
		mockFileName: String = "GetGames_Success"
	) {
		self.devMode = devMode
		self.mockFileName = mockFileName
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.shared.getInstanceURL(),
                                              forceClient: ForceClient(auth: authManager))
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
            let result = try await loyaltyAPIManager.getGames(participantId: "0lMSB000000021p2AA",
															  devMode: devMode,
															  mockFileName: mockFileName
			)
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
