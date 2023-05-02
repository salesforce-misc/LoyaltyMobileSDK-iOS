/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A protocol that defines the necessary methods for handling access tokens in the Salesforce API.
public protocol ForceAuthenticator {
    
    /// Get a valid access token.
    /// - Returns: A valid access token as a `String` if available, otherwise `nil`.
    func getAccessToken() -> String?
    
    /// Grant (or refresh) an access token.
    /// - Returns: A refreshed or newly granted access token as a `String`.
    func grantAccessToken() async throws -> String
}
