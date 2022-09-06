//
//  ForceSwift.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public struct ForceConfig {
    
    static let defaultVersion = "54.0" // Spring '22
    
    static func path(for api: String, version: String = defaultVersion) -> String {
        "/services/data/v\(version)/\(api)"
    }
}
