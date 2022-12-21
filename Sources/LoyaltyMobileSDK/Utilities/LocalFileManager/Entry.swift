//
//  Entry.swift
//  LoyaltyMobileSDK
//
//  Created by Leon Qi on 11/4/22.
//

import Foundation

// A wrapper around cached object and its expiry date.
public struct Entry<T: Codable>: Codable {
    // Cached object
    public let object: T
    // Expiry date
    public let expiry: Expiry
    // File path to the cached object
    public let filePath: URL
}
