/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public struct ForceConfig {
    
    public static let defaultVersion = "56.0" // latest version
    public static let defaultAuthURL = "https://login.salesforce.com/services/oauth2/authorize"
    public static let defaultTokenURL = "https://login.salesforce.com/services/oauth2/token"
    public static let defaultRevokeURL = "https://login.salesforce.com/services/oauth2/revoke"
    public static let defaultServiceIdentifier = "com.salesforce.industries.mobile"
    
    public static func path(for api: String, version: String = defaultVersion) -> String {
        "/services/data/v\(version)/\(api)"
    }
    
    /*
        Client side configuration
        Create a salesforce.json file in client side or in a centralized location
        For example:
             {
                 "consumerKey" : "YOUR_CONNECTED_APP_CONSUMER_KEY",
                 "consumerSecret": "YOUR_CONNECTED_APP_CONSUMER_SECRET",
                 "callbackURL" : "YOUR_CONNECTED_APP_CALLBACK_URL",
                 "authURL": "https://login.salesforce.com/services/oauth2/token",
                 "instanceURL": "YOUR_ORG_INSTANCE_URL",
                 "username": "YOUR_LOGIN_USERNAME",
                 "password": "YOUR_LOGIN_PASSWORD"
             }
     */
    public static func config(configurationURL: URL? = nil, session: URLSession = .shared) throws -> Configuration {
        
        guard let url =
                configurationURL
                ?? Bundle.main.url(forResource: "Salesforce", withExtension: "json")
                ?? Bundle.main.url(forResource: "salesforce", withExtension: "json") else {
                throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey : "Salesforce.json"])
        }
        return try JSONDecoder().decode(Configuration.self, from: try Data(contentsOf: url))
    }
}

extension ForceConfig {
    
    public struct Configuration: Decodable {
    
        public let consumerKey: String
        public let consumerSecret: String
        public let callbackURL: String
        public let authURL: String
        public let instanceURL: String
        public let username: String
        public let password: String
    }
}
