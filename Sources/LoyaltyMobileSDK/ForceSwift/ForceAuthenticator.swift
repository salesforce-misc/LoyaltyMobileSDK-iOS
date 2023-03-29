/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public protocol ForceAuthenticator {

    /// A valid accessToken
    var accessToken: String? { get set }
    /// Grant an accessToken which can be used to access Salesforce APIs
    /// - Returns: A valid accessToken
    func grantAccessToken() async throws -> String
}
