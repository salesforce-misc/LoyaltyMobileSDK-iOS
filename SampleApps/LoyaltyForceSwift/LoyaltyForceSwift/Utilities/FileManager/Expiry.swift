//
//  Expiry.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/4/22.
//

import Foundation

/**
 Helper enum to set the expiration date
 */
public enum Expiry: Codable {
    // Object will be expired in the nearest future
    case never
    // Object will be expired on the specified date
    // For example, `Date().addingTimeInterval(60*60)` or `Date(timeIntervalSinceNow: 60*60)`
    case date(Date)
    
    // Returns the appropriate date object
    public var date: Date {
        switch self {
        case .never:
            // Ref: https://lists.apple.com/archives/cocoa-dev/2005/Apr/msg01833.html
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68)
        case .date(let date):
            return date
        }
    }
    
    // Checks if cached object is expired according to expiration date
    public var isExpired: Bool {
        return date.inThePast
    }
}
