//
//  Auth.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public struct ForceAuth {
    public let accessToken: String
    public let instanceURL: URL
    public let identityURL: URL?
    public let timestamp: Date
    public let refreshToken: String?
}

