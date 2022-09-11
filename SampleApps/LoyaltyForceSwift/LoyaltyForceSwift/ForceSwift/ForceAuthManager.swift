//
//  ForceAuthManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ForceAuthManager {
    
    var auth:ForceAuth? = nil
    var config:ForceConfig.Configuration? = nil
    
    static let shared = ForceAuthManager()
    
    private init(){
        Task {
            self.config = try ForceConfig.config()
            self.auth = try await ForceAuthManager.shared.grantAuth(
                url: config!.authURL,
                username: config!.username,
                password: config!.password,
                consumerKey: config!.consumerKey,
                consumerSecret: config!.consumerSecret)
        }
    }
    
    func getAuth() -> ForceAuth?{
        return self.auth
    }
    
    func clearAuth(){
        self.auth = nil
    }
    
    func grantAuth() async throws{
        self.config = try ForceConfig.config()
        self.auth = try await ForceAuthManager.shared.grantAuth(
            url: self.config!.authURL,
            username: self.config!.username,
            password: self.config!.password,
            consumerKey: self.config!.consumerKey,
            consumerSecret: self.config!.consumerSecret)

    }
    
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
            self.auth = try await ForceClient.shared.fetch(type: ForceAuth.self, with: request)
            return self.auth!
            
        } catch {
            throw error
        }
        
    }
}
