/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ForceAuth
public struct ForceAuth: Codable {
    public let accessToken: String
    public let instanceURL: String
    public let identityURL: String
    public let tokenType: String?
    public let timestamp: String?
    public let signature: String?
    public let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case instanceURL = "instance_url"
        case identityURL = "id"
        case tokenType = "token_type"
        case timestamp = "issued_at"
        case signature
        case refreshToken = "refresh_token"
    }
    
    public var host: String {
        guard let url = URL(string: instanceURL) else { return "" }
        guard let host = url.host else { return ""}
        return host
    }
    
    /// The ID of the Salesforce User record associated with this credential.
    public var userID: String {
        guard let url = URL(string: identityURL) else { return "" }
        return url.lastPathComponent
    }
    
    /// The ID of the Salesforce Organization record associated with this credential.
    public var orgID: String {
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
