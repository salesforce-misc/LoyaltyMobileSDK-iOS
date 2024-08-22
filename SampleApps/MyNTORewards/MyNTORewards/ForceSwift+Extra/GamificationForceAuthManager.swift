//
//  GamificationForceAuthManager.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 20/12/23.
//

import Foundation
import GamificationMobileSDK

public class GamificationForceAuthManager: GamificationForceAuthenticator, ObservableObject {
    @Published public var auth: ForceAuth?
    public static let shared = GamificationForceAuthManager()
    
    private init() {
        self.auth = ForceAuthManager.shared.getAuth()
    }
    
    public func getAccessToken() -> String? {
        ForceAuthManager.shared.getAccessToken()
    }
    
    public func grantAccessToken() async throws -> String {
        try await ForceAuthManager.shared.grantAccessToken()
    }    
}
