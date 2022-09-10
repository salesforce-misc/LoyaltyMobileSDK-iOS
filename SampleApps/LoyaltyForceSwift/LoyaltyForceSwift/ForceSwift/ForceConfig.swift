//
//  ForceSwift.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public struct ForceConfig {
    
    static let defaultVersion = "55.0" // Summer '22
    
    // Base on the connected app config
    static let consumerKey = "3MVG9kBt168mda_.AhACC.RZAxIT77sS1y2_ltn1YMi4tG98ZA1nMiP2w6m51xen0Of_0TWZ8RTvPy05bK5p9"
    static let consumerSecret = "F89D25E00C8295DBDD0F8AD08750E69633B6E46B6515AA8BED7D30CDEEA2BD5E"
    
    static let username = "admin_aa_22852@loyaltysampleapp.com"
    static let password = "test@123"
    
    static let authURL = "https://login.salesforce.com/services/oauth2/token"
    
    static func path(for api: String, version: String = defaultVersion) -> String {
        "/services/data/v\(version)/\(api)"
    }
}
