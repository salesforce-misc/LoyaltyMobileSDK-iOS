//
//  Auth.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

// MARK: - ForceAuth
struct ForceAuth: Codable {
    let accessToken: String
    let instanceURL: String
    let identityURL: String
    let tokenType: String?
    let timestamp: String?
    let signature: String?
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case instanceURL = "instance_url"
        case identityURL = "id"
        case tokenType = "token_type"
        case timestamp = "issued_at"
        case signature
        case refreshToken = "refresh_token"
    }
    
    var host: String {
        guard let url = URL(string: instanceURL) else { return "" }
        guard let host = url.host else { return ""}
        return host
    }
    
    /// The ID of the Salesforce User record associated with this credential.
    var userID: String {
        guard let url = URL(string: identityURL) else { return "" }
        return url.lastPathComponent
    }
    
    /// The ID of the Salesforce Organization record associated with this credential.
    var orgID: String {
        guard let url = URL(string: identityURL) else { return "" }
        return url.deletingLastPathComponent().lastPathComponent
    }
}

internal extension ForceAuth {
    
    init(PercentEncodedURL: String) throws {
        
        var comps = URLComponents()
        comps.percentEncodedQuery = PercentEncodedURL
        
        // Non-nillable properties
        guard let queryItems: [URLQueryItem] = comps.queryItems,
              let accessToken: String = queryItems["access_token"],
              let instanceURL: String = queryItems["instance_url"],
              let identityURL: String = queryItems["id"] else {
            throw URLError(.badServerResponse)
        }

        // Nillable properties
        let tokenType: String? = queryItems["token_type"] ?? ""
        let timestamp: String? = queryItems["issued_at"] ?? ""
        let signature: String? = queryItems["signature"] ?? ""
        let refreshToken: String? = queryItems["refresh_token"] ?? ""
        
        
        self.init(
            accessToken: accessToken,
            instanceURL: instanceURL,
            identityURL: identityURL,
            tokenType: tokenType,
            timestamp: timestamp,
            signature: signature,
            refreshToken: refreshToken
        )
    }
}
