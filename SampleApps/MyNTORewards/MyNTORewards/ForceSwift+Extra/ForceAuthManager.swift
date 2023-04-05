/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import LoyaltyMobileSDK

public class ForceAuthManager: ForceAuthenticator {
    public var accessToken: String?
    public var auth: ForceAuth? = nil
    private let defaults: UserDefaults
    
    public enum OauthFlow {
        case UserAgent
        case UsernamePassword
    }
    
    public static let shared = ForceAuthManager()
    
    private init(defaults: UserDefaults = .shared) {
        self.defaults = defaults
    }
    
    public func grantAccessToken() async throws -> String {
        do {
            // accessToken may be invalid, then refresh
            if self.auth != nil {
                if let refreshToken = self.auth?.refreshToken {
                    let app = AppSettings.getConnectedApp()
                    let url = app.baseURL + AppSettings.Defaults.tokenPath
                    do {
                        let newAuth = try await refresh(url: url, consumerKey: app.consumerKey, refreshToken: refreshToken)
                        self.auth = newAuth
                        return newAuth.accessToken
                    } catch {
                        throw error
                    }
                }
            }
            
            guard let auth = getAuth() else {
                throw ForceError.authenticationFailed
            }
            return auth.accessToken
        } catch {
            throw error
        }
    }
    
    /// Unique identifier for current Salesforce user.
    public var userIdentifier: ForceUserIdentifier? {
        get {
            return defaults.userIdentifier
        }
        set {
            self.defaults.userIdentifier = newValue
        }
    }
    
    public func getAuth() -> ForceAuth? {
        return self.auth
    }
    
    public func clearAuth() {
        guard let auth = self.auth else {
            return
        }
        defer {
            self.auth = nil
        }
        Task {
            do {
                let revokeURL = AppSettings.getConnectedApp().baseURL + AppSettings.Defaults.revokePath
                try await self.revoke(url: revokeURL, token: auth.accessToken)
            } catch {
                print("Failed to revolk token")
            }
            
        }
        
    }
    
    public func grantAuth(oauthFlow: OauthFlow = .UsernamePassword) async throws {
        
        do {
            let app = AppSettings.getConnectedApp()
            let tokenURL = app.baseURL + AppSettings.Defaults.tokenPath
            let authURL = app.baseURL + AppSettings.Defaults.authPath
            
            switch oauthFlow {
            case .UsernamePassword:
                self.auth = try await self.grantAuth(
                    url: tokenURL,
                    username: app.username,
                    password: app.password,
                    consumerKey: app.consumerKey,
                    consumerSecret: app.consumerSecret)
            case .UserAgent:
                self.auth = try await self.authenticate(url: authURL, consumerKey: app.consumerKey, callbackURL: app.callbackURL)
            }
        } catch {
            throw error
        }

    }
    
    /// OAuth 2.0 Username-Password Flow - Use username and password behind screen to obtain a valid accessToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_username_password_flow.htm&type=5
    public func grantAuth(url: String, username: String, password: String, consumerKey: String, consumerSecret: String) async throws -> ForceAuth {
        
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
            let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
            let auth = try await NetworkManager.shared.fetch(type: ForceAuth.self, request: request)
            try saveAuth(for: auth)
            return auth
            
        } catch {
            throw error
        }
        
    }
    
    /// OAuth 2.0 User-Agent Flow - This will bring up Salesforce Login Page. After sucessfully login, will get an accessToken and a refreshToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_user_agent_flow.htm&type=5
    public func authenticate(url: String, consumerKey: String, callbackURL: String, state: String? = nil, loginHint: String? = nil) async throws -> ForceAuth {
        
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
    
    /// OAuth 2.0 Refresh Token Flow - use refresh token to get a new accessToken
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_refresh_token_flow.htm&type=5
    /// If consumerSecret is not used, then be sure that "Require Secret for Refresh Token Flow" is not checked in Connected App settings. If "Require Secret for Refresh Token Flow" is checked, consumerSecret must be provided.
    public func refresh(url: String, consumerKey: String, consumerSecret: String? = nil, refreshToken: String) async throws -> ForceAuth {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var queryItems = [
            "grant_type": "token",
            "client_id": consumerKey,
            "fresh_token": refreshToken
        ]
        consumerSecret.map { queryItems["client_secret"] = $0 }
        
        do {
            let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
            let auth = try await NetworkManager.shared.fetch(type: ForceAuth.self, request: request)
            try saveAuth(for: auth)
            return auth
            
        } catch {
            throw error
        }
        
    }
    
    /// Revoke OAuth token (access token or refresh token)
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_revoke_token.htm&type=5
    public func revoke(url: String, token: String) async throws -> Void {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let queryItems = ["token": token]
        
        do {
            let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
            let _ = try await URLSession.shared.data(for: request)
            try deleteAuth()
            print("Revoke successful")
        } catch {
            throw error
        }

    }
    
    /// OAuth 2.0 Authorization Code and Credentials Flow
    /// https://help.salesforce.com/s/articleView?id=sf.remoteaccess_authorization_code_credentials_flow.htm&type=5
    public func authenticate(communityURL: String, consumerKey: String, callbackURL: String, username: String, password: String) async throws -> ForceAuth {

        guard let url = URL(string: communityURL),
            let callbackURL = URL(string: callbackURL) else {
            throw URLError(.badURL)
        }

        var authURL: URL
        var tokenURL: URL

        if #available(iOS 16, *) {
            authURL = url.appending(path: "/services/oauth2/authorize")
            tokenURL = url.appending(path: "/services/oauth2/token")
        } else {
            authURL = url.appendingPathComponent("/services/oauth2/authorize")
            tokenURL = url.appendingPathComponent("/services/oauth2/token")
        }

        do {
            guard let code = try await requestAuthorizationCode(url: authURL, consumerKey: consumerKey, callbackURL: callbackURL, username: username, password: password) else {
                throw ForceError.codeCredentials
            }

            return try await requestAccessToken(url: tokenURL, authCode: code, consumerKey: consumerKey, callbackURL: callbackURL)

        } catch {
            throw error
        }
    }
    
    /// Part 1 - Makes a Headless Request for an Authorization Code
    private func requestAuthorizationCode(url: URL, consumerKey: String, callbackURL: URL, username: String, password: String) async throws -> String? {

        let queryItems = [
            "scope": "api refresh_token", // These scopes need to be selected from Connected App Settings
            "response_type": "code_credentials",
            "client_id": consumerKey,
            "redirect_uri": callbackURL.absoluteString,
            "username": username,
            "password": password
        ]

        let headers = [
            "Auth-Request-Type": "Named-User"
        ]

        do {
            let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems, headers: headers)

            let output = try await URLSession.shared.data(for: request)

            guard let response = output.1 as? HTTPURLResponse,
                  let url = response.url,
                  response.statusCode == 401 else {
                throw ForceError.codeCredentials
            }

            guard let authCode = getAuthorizationCode(fromUrl: url) else {
                throw ForceError.codeCredentials
            }
            print(authCode)
            return authCode

        } catch {
            throw error
        }

    }

    /// Part 2 - Requests an Access Token (and Refresh Token)
    private func requestAccessToken(url: URL, authCode: String, consumerKey: String, callbackURL: URL) async throws -> ForceAuth {

        let queryItems = [
            "code": authCode,
            "grant_type": "authorization_code",
            "client_id": consumerKey,
            "redirect_uri": callbackURL.absoluteString
        ]

        do {
            let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
            let auth = try await NetworkManager.shared.fetch(type: ForceAuth.self, request: request)

            print(auth)
            try saveAuth(for: auth)
            return auth

        } catch {
            throw error
        }

    }

    private func getAuthorizationCode(fromUrl: URL) -> String? {

        guard let components = URLComponents(url: fromUrl, resolvingAgainstBaseURL: false) else {
            return nil
        }

        guard let queryItems = components.queryItems else {
            return nil
        }

        guard let code = queryItems["code"] else {
            return nil
        }

        return code.replacingOccurrences(of: "%3D", with: "=")

    }
    
    /// Save Auth to ForceAuthStore
    public func saveAuth(for auth: ForceAuth) throws {
        do {
            try ForceAuthStore.save(auth: auth)
            defaults.userIdentifier = auth.identityURL
        } catch {
            throw error
        }
    }
    
    /// Delete Auth from ForceAuthStore
    public func deleteAuth() throws {
        if let id = self.userIdentifier {
            try? ForceAuthStore.delete(for: id)
        }
    }
    
    /// Retrieve Auth from ForceAuthStore
    public func retrieveAuth() throws -> ForceAuth {
        guard let id = ForceAuthManager.shared.userIdentifier else {
            throw ForceError.userIdentityUnknown
        }
        guard let auth = try ForceAuthStore.retrieve(for: id) else {
            throw ForceError.authNotFoundInKeychain
        }
        return auth
    }
    
}
