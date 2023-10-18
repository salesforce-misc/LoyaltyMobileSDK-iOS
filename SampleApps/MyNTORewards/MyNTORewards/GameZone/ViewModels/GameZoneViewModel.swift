//
//  GameZoneViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import Foundation
import LoyaltyMobileSDK

enum LoadingState {
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
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.shared.getInstanceURL(),
                                              forceClient: ForceClient(auth: authManager))
    }
    
    func getGames(memberId: String, reload: Bool = false, devMode: Bool = false) async throws {
        state = .loading
        do {
            try await fetchGames(memberId: memberId, devMode: devMode)
            self.state = .loaded
        } catch {
            self.state = .failed(error)
            throw error
        }
    }
    
    func fetchGames(memberId: String, devMode: Bool = false) async throws {
        do {
            let result = try await loyaltyAPIManager.getGames(membershipId: memberId, devMode: true)
            activeGameDefinitions = result.gameDefinitions.filter({$0.status == .active})
            playedGameDefinitions = result.gameDefinitions.filter({$0.status == .played})
            expiredGameDefinitions = result.gameDefinitions.filter({$0.status == .expired})
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
        try await fetchGames(memberId: id)
    }
}
