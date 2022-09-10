//
//  Auth.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

//import Foundation
//
//public struct ForceAuth {
//    public let accessToken: String
//    public let instanceURL: URL
//    public let identityURL: URL?
//    public let timestamp: Date
//    public let refreshToken: String?
//}
import Foundation

// MARK: - ForceAuth
struct ForceAuth: Codable {
    let accessToken: String
    let instanceURL: String
    let identityURL: String
    let tokenType: String?
    let timestamp: String?
    let signature: String?
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case instanceURL = "instance_url"
        case identityURL = "id"
        case tokenType = "token_type"
        case timestamp = "issued_at"
        case signature
        case refreshToken = "refresh_token"
    }
}
