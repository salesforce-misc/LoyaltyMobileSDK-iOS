/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public enum CommonError: Error, Equatable {

    // 0
    case requestFailed(message: String)
    // 1
    case jsonConversionFailure(message: String)
    // 2
    case invalidData
    // 3
    case responseUnsuccessful(message: String)
    // 4
    case authenticationNeeded
    // 5
    case userIdentityUnknown
    // 6
    case authNotFoundInKeychain
    // 7
    case authenticationFailed
    // 8
    case codeCredentials
    
}

extension CommonError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .requestFailed(message): return "Request Failed Error -> \(message)"
        case .invalidData: return "Invalid Data Error"
        case let .responseUnsuccessful(message): return "Response Unsuccessful Error -> \(message)"
        case let .jsonConversionFailure(message): return "JSON Conversion Failure -> \(message)"
        case .authenticationNeeded: return "Authentication is need."
        case .userIdentityUnknown: return "User Identity has not been set."
        case .authNotFoundInKeychain: return "Cannot find the auth from Keychain."
        case .authenticationFailed: return "Authentication failed."
        case .codeCredentials: return "Authorization code and credentials flow failed."
        }
    }
}
