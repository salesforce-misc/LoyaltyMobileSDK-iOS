//
//  ForceSwift.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public struct ForceConfig {
    
    static let defaultVersion = "56.0" // latest version
    static let defaultAuthURL = "https://login.salesforce.com/services/oauth2/authorize"
    static let defaultTokenURL = "https://login.salesforce.com/services/oauth2/token"
    static let defaultRevokeURL = "https://login.salesforce.com/services/oauth2/revoke"
    static let defaultConsumerKey = "3MVG9kBt168mda_.AhACC.RZAxIT77sS1y2_ltn1YMi4tG98ZA1nMiP2w6m51xen0Of_0TWZ8RTvPy05bK5p9"
    static let defaultInstanceURL = "https://internalmobileteam-dev-ed.develop.my.salesforce.com"
    
    static func path(for api: String, version: String = defaultVersion) -> String {
        "/services/data/v\(version)/\(api)"
    }
    
    static func config(configurationURL: URL? = nil, session: URLSession = .shared) throws -> Configuration {
        
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
    
    struct Configuration: Decodable {
    
        let consumerKey: String
        let consumerSecret: String
        let callbackURL: String
        let authURL: String
        let instanceURL: String
        let username: String
        let password: String
    }
}
