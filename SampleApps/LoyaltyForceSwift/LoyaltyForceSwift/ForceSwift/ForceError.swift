//
//  APIError.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation

public enum ForceError: Error {

    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    case failedSerialization

    var customDescription: String {
        switch self {
        case let .requestFailed(description): return "Request Failed Error -> \(description)"
        case .invalidData: return "Invalid Data Error"
        case let .responseUnsuccessful(description): return "Response Unsuccessful Error -> \(description)"
        case .jsonParsingFailure: return "JSON Parsing Failure Error"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
        case .noInternet: return "No internet connection"
        case .failedSerialization: return "Serialization print for debug failed."
        }
    }
}
