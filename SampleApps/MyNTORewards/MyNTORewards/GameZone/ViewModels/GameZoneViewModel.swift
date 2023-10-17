//
//  GameZoneViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class GameZoneViewModel: ObservableObject {
    
    @Published var playedGameDefinitions: [GameDefinition]?
    @Published var activeGameDefinitions: [GameDefinition]?
    @Published var expiredGameDefinitions: [GameDefinition]?
    @Published var isLoading = false
    
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
    
    func getGames(memberId: String, reload: Bool = false, devMode: Bool = false) async throws {
        isLoading = true
        do {
            try await fetchGames(memberId: memberId, devMode: devMode)
            isLoading = false
        } catch {
            throw error
        }
        isLoading = false
    }
    
    func fetchGames(memberId: String, devMode: Bool = false) async throws {
        do {
            
            let result = try await loyaltyAPIManager.getGames(membershipId: memberId, devMode: true)
            activeGameDefinitions = result.gameDefinitions.filter({$0.status == .active})
            playedGameDefinitions = result.gameDefinitions.filter({$0.status == .played})
            expiredGameDefinitions = result.gameDefinitions.filter({$0.status == .expired})

        } catch {
            throw error
        }
    }
    
    func clear() {
        activeGameDefinitions = nil
        playedGameDefinitions = nil
        expiredGameDefinitions = nil
    }
}
