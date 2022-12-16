//
//  Collection+URLQueryItem.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/12/22.
//

import Foundation

/// https://www.avanderlee.com/swift/url-components/
public extension Collection where Element == URLQueryItem {
    
    subscript(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}
