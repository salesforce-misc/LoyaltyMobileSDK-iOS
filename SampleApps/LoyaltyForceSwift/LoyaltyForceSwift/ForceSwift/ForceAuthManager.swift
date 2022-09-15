//
//  ForceAuthManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ForceAuthManager {
    
    var auth: ForceAuth? = nil
    private let defaults: UserDefaults
    
    enum OauthFlow {
        case UserAgent
        case UsernamePassword
    }
    
    static let shared = ForceAuthManager()
    
    /// Unique identifier for current Salesforce user.
    public var userIdentifier: ForceUserIdentifier? {
        get {
            return defaults.userIdentifier
        }
        set {
            self.defaults.userIdentifier = newValue
        }
    }
    
    private init(defaults: UserDefaults = .shared) {
        self.defaults = defaults
    }
    
    func getAuth() -> ForceAuth? {
        return self.auth
    }
    
    func clearAuth() {
        guard let auth = self.auth else {
            return
        }
        defer {
            self.auth = nil
        }
        Task {
            do {
                try await self.revoke(token: auth.accessToken)
            } catch {
                print("Failed to revolk token")
            }
            
        }
        
    }
    
    func grantAuth(oauthFlow: OauthFlow = .UsernamePassword) async throws {
        
        do {
            let config = try ForceConfig.config()
            
            switch oauthFlow {
            case .UsernamePassword:
                self.auth = try await self.grantAuth(
                    url: config.authURL,
                    username: config.username,
                    password: config.password,
                    consumerKey: config.consumerKey,
                    consumerSecret: config.consumerSecret)
            case .UserAgent:
                self.auth = try await self.authenticate(consumerKey: config.consumerKey, callbackURL: config.callbackURL)
            }
        } catch {
            throw error
        }

    }
    
    /// OAuth 2.0 Username-Password Flow - Use username and password behind screen to obtain a valid accessToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_username_password_flow.htm&type=5
    func grantAuth(url: String, username: String, password: String, consumerKey: String, consumerSecret: String) async throws -> ForceAuth {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let queryItems = [
            "username": username,
            "password": password,
            "grant_type": "password",
            "client_id": consumerKey,
            "client_secret": consumerSecret
        ]
        
        do {
            let request = try ForceRequest.create(url: url, method: ForceRequest.Method.post, queryItems: queryItems)
            let auth = try await ForceClient.shared.fetch(type: ForceAuth.self, with: request)
            try saveAuth(for: auth)
            return auth
            
        } catch {
            throw error
        }
        
    }
    
    /// OAuth 2.0 User-Agent Flow - This will bring up Salesforce Login Page. After sucessfully login, will get an accessToken and a refreshToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_user_agent_flow.htm&type=5
    func authenticate(url: String = ForceConfig.defaultAuthURL, consumerKey: String, callbackURL: String, state: String? = nil, loginHint: String? = nil) async throws -> ForceAuth {
        
        guard let url = URL(string: url),
            let callbackURL = URL(string: callbackURL) else {
            throw URLError(.badURL)
        }
        
        var queryItems = [
            "response_type" : "token",
            "client_id" : consumerKey,
            "redirect_uri" : callbackURL.absoluteString,
            "prompt" : "login consent",
            "display" : "touch"
        ]
        state.map { queryItems["state"] = $0 }
        loginHint.map { queryItems["login_hint"] = $0 }
        
        do {
            let authURL = try ForceRequest.transform(from: url, add: queryItems)
            guard let scheme = callbackURL.scheme else {
                throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: callbackURL])
            }
            let redirectURL = try await WebAuthenticationSession.shared.start(url: authURL, callbackURLScheme: scheme)
            guard let encodedQueryString = redirectURL.fragment else {
                throw URLError(.badServerResponse)
            }
            let auth = try ForceAuth(PercentEncodedURL: encodedQueryString)
            try saveAuth(for: auth)
            return auth
        } catch {
            throw error
        }
        
        
    }
    
    /// OAuth 2.0 Rrefresh Token Flow - use refresh token to get a new accessToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_refresh_token_flow.htm&type=5
    /// If consumerSelect is not used, then be sure that "Require Secret for Refresh Token Flow" is not checked in Connected App settings. If "Require Secret for Refresh Token Flow" is checked, consumerSelect must be provided.
    func refresh(url: String = ForceConfig.defaultTokenURL, consumerKey: String, consumerSelect: String? = nil, refreshToken: String) async throws -> ForceAuth {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var queryItems = [
            "grant_type": "token",
            "client_id": consumerKey,
            "fresh_token": refreshToken
        ]
        consumerSelect.map { queryItems["client_secret"] = $0 }
        
        do {
            let request = try ForceRequest.create(url: url, method: ForceRequest.Method.post, queryItems: queryItems)
            let auth = try await ForceClient.shared.fetch(type: ForceAuth.self, with: request)
            try saveAuth(for: auth)
            return auth
            
        } catch {
            throw error
        }
        
    }
    
    /// Revoke OAuth token (access token or refresh token)
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_revoke_token.htm&type=5
    func revoke(url: String = ForceConfig.defaultRevokeURL, token: String) async throws -> Void {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let queryItems = ["token": token]
        
        do {
            let request = try ForceRequest.create(url: url, method: ForceRequest.Method.post, queryItems: queryItems)
            let _ = try await URLSession.shared.data(for: request)
            try deleteAuth()
            print("Revoke successful")
        } catch {
            throw error
        }

    }
    
    /// Save Auth to ForceAuthStore
    func saveAuth(for auth: ForceAuth) throws {
        do {
            try ForceAuthStore.save(auth: auth)
            defaults.userIdentifier = auth.identityURL
        } catch {
            throw error
        }
    }
    
    /// Delete Auth from ForceAuthStore
    func deleteAuth() throws {
        if let id = self.userIdentifier {
            try? ForceAuthStore.delete(for: id)
        }
    }
    
    /// Retrieve Auth from ForceAuthStore
    func retrieveAuth() throws -> ForceAuth {
        guard let id = ForceAuthManager.shared.userIdentifier else {
            throw ForceError.userIdentityUnknown
        }
        guard let auth = try ForceAuthStore.retrieve(for: id) else {
            throw ForceError.authNotFoundInKeychain
        }
        return auth
    }
    
}
