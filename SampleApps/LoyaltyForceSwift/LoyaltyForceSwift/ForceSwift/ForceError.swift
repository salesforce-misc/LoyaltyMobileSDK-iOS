//
//  APIError.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public enum ForceError: Error, Equatable {

    // 0
    case requestFailed(description: String)
    // 1
    case jsonConversionFailure(description: String)
    // 2
    case invalidData
    // 3
    case responseUnsuccessful(description: String)
    // 4
    case jsonParsingFailure
    // 5
    case noInternet
    // 6
    case failedSerialization
    // 7
    case authenticationNeeded
    // 8
    case userIdentityUnknown
    // 9
    case authNotFoundInKeychain

    var customDescription: String {
        switch self {
        case let .requestFailed(description): return "Request Failed Error -> \(description)"
        case .invalidData: return "Invalid Data Error"
        case let .responseUnsuccessful(description): return "Response Unsuccessful Error -> \(description)"
        case .jsonParsingFailure: return "JSON Parsing Failure Error"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
        case .noInternet: return "No internet connection"
        case .failedSerialization: return "Serialization print for debug failed."
        case .authenticationNeeded: return "Authentication is need."
        case .userIdentityUnknown: return "User Identity has not been set."
        case .authNotFoundInKeychain: return "Cannot find the auth from Keychain."
        }
    }
}
