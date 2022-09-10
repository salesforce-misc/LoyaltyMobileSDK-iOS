//
//  ForceSwift.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public struct ForceConfig {
    
    static let defaultVersion = "55.0" // Summer '22
  
//    // Org
//    static let instanceURL = "https://internalmobileteam-dev-ed.develop.my.salesforce.com"
//
//    // Base on the connected app config
//    static let consumerKey = "3MVG9kBt168mda_.AhACC.RZAxIT77sS1y2_ltn1YMi4tG98ZA1nMiP2w6m51xen0Of_0TWZ8RTvPy05bK5p9"
//    static let consumerSecret = "F89D25E00C8295DBDD0F8AD08750E69633B6E46B6515AA8BED7D30CDEEA2BD5E"
//
//    // Salesforce User
//    static let username = "admin_aa_22852@loyaltysampleapp.com"
//    static let password = "test@123"
//
//    // Salesforce Oauth URL
//    static let authURL = "https://login.salesforce.com/services/oauth2/token"
    
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
        let callbackURL: URL
        let authURL: String
        let instanceURL: String
        let username: String
        let password: String
    }
}
