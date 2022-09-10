//
//  ForceAuthManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ForceAuthManager {
    
    static let shared = ForceAuthManager()
    
    private init() {}
    
    func grantAuth(username: String, password: String) async throws -> ForceAuth {
        
        let queryItems = [
            "username": username,
            "password": password,
            "grant_type": "password",
            "client_id": ForceConfig.consumerKey,
            "client_secret": ForceConfig.consumerSecret
        ]
        
        guard let url = URL(string: ForceConfig.authURL) else {
            throw URLError(.badURL)
        }
        
        do {
            let request = try ForceRequest.create(url: url, method: ForceRequest.Method.post, queryItems: queryItems)
            return try await ForceClient.shared.fetch(type: ForceAuth.self, with: request)
            
        } catch {
            throw error
        }
        
    }
}
