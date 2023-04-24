/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public protocol ForceAuthenticator {
    
    /// Get a valid accessToken
    /// - Returns: An accessToken or ``Nil``
    func getAccessToken() -> String?
    
    /// Greant(or refresh) accessToken
    /// - Returns: An accessToken
    func grantAccessToken() async throws -> String
}
