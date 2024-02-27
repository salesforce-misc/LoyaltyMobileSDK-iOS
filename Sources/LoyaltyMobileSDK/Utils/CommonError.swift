/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A custom error enumeration for handling common errors in the application.
public enum CommonError: Error, Equatable {
    case requestFailed(message: String)
    case jsonConversionFailure(message: String)
    case invalidData
	case responseUnsuccessful(message: String, displayMessage: String)
    case authenticationNeeded
    case userIdentityUnknown
    case authNotFoundInKeychain
    case authenticationFailed
    case codeCredentials
    case functionalityNotEnabled
	case unknownException(displayMessage: String)
    case sessionExpired
    case urlEncodingFailed
    case imageConversionError
}

extension CommonError: CustomStringConvertible, LocalizedError {
    
    /// Provides a human-readable description of the error.
    public var description: String {
        // Each case returns a custom error message
        switch self {
        case let .requestFailed(message):
            return "Request Failed Error -> \(message)"
        case .invalidData:
            return "Invalid Data Error"
        case let .responseUnsuccessful(message, _):
            return "Response Unsuccessful Error -> \(message)"
        case let .jsonConversionFailure(message):
            return "JSON Conversion Failure -> \(message)"
        case .authenticationNeeded:
            return "Authentication is need."
        case .userIdentityUnknown:
            return "User Identity has not been set."
        case .authNotFoundInKeychain:
            return "Cannot find the auth from Keychain."
        case .authenticationFailed:
            return "Authentication failed."
        case .codeCredentials:
            return "Authorization code and credentials flow failed."
        case .functionalityNotEnabled:
            return "Functionality is not enabled."
        case .unknownException:
            return "An unexpected error occurred."
        case .sessionExpired:
            return "You sesssion has expired."
        case .urlEncodingFailed:
            return "Failed to encode the string."
        case .imageConversionError:
            return "Failed to convert UIImage to Data."
        }
    }
    
    /// Provides a localized error description for the error.
    public var errorDescription: String? {
        // Each case returns a custom localized error message
        switch self {
        case let .requestFailed(message):
            return NSLocalizedString("Request Failed Error -> \(message)", comment: "Request Failed Error")
        case .invalidData:
            return NSLocalizedString("Invalid Data Error", comment: "Invalid Data Error")
        case let .responseUnsuccessful(message, _):
            return NSLocalizedString("Response Unsuccessful Error -> \(message)", comment: "Response Unsuccessful Error")
        case let .jsonConversionFailure(message):
            return NSLocalizedString("JSON Conversion Failure -> \(message)", comment: "JSON Conversion Failure")
        case .authenticationNeeded:
            return NSLocalizedString("Authentication is need.", comment: "Authentication Needed Error")
        case .userIdentityUnknown:
            return NSLocalizedString("User Identity has not been set.", comment: "User Identity Unknown Error")
        case .authNotFoundInKeychain:
            return NSLocalizedString("Cannot find the auth from Keychain.", comment: "Auth Not Found In Keychain Error")
        case .authenticationFailed:
            return NSLocalizedString("Authentication failed.", comment: "Authentication Failed Error")
        case .codeCredentials:
            return NSLocalizedString("Authorization code and credentials flow failed.", comment: "Code Credentials Error")
        case .functionalityNotEnabled:
            return NSLocalizedString("Functionality is not enabled.", comment: "Functionality Not Enabled Error")
        case .unknownException:
            return NSLocalizedString("An unexpected error occurred.", comment: "Unknown Exception Error")
        case .sessionExpired:
            return NSLocalizedString("Your session has expired.", comment: "Session Expired Error")
        case .urlEncodingFailed:
            return NSLocalizedString("Failed to encode the string.", comment: "URL Encoding Error")
        case .imageConversionError:
            return NSLocalizedString("Failed to convert UIImage to Data.", comment: "Image Conversion Error")
        }
    }
}
