//
//  GamificationForceAuthManager.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 20/12/23.
//

import Foundation
import GamificationMobileSDK_iOS

public class GamificationForceAuthManager: GamificationForceAuthenticator, ObservableObject {
    @Published public var auth: ForceAuth?
    public static let shared = GamificationForceAuthManager()
    
    private init() {
        self.auth = getAuth()
    }
    
    public func getAccessToken() -> String? {
        if let auth = getAuth() {
            return auth.accessToken
        } else {
            return nil
        }
    }
    
    public func getAuth() -> ForceAuth? {
        if let auth = self.auth {
            return auth
        } else {
            do {
                let savedAuth = try retrieveAuth()
                DispatchQueue.main.async {
                    self.auth = savedAuth
                }
                return savedAuth
            } catch {
                GamificationLogger.error("No auth found. Please login.")
            }
        }
        return nil
    }
    
    public func grantAccessToken() async throws -> String {
        let app = AppSettings.shared.getConnectedApp()
        _ = app.baseURL + AppSettings.Defaults.tokenPath
        
        let savedAuth = try retrieveAuth()
        self.auth = savedAuth
        return savedAuth.accessToken
    }
    
    // swiftlint:disable line_length
    /// Retrieve Auth from Keychain
    public func retrieveAuth<KeychainManagerType: KeychainManagerProtocol>(using keychainManagerType: KeychainManagerType.Type) throws -> ForceAuth where KeychainManagerType.T == ForceAuth {
        guard let id = UserDefaults.shared.userIdentifier else {
            throw CommonError.userIdentityUnknown
        }
        guard let auth = try KeychainManagerType.retrieve(for: id) else {
            throw CommonError.authNotFoundInKeychain
        }
        return auth
    }
    // swiftlint:enable line_length
    
    public func retrieveAuth() throws -> ForceAuth {
        try retrieveAuth(using: ForceAuthKeychainManager.self)
    }
    
}
