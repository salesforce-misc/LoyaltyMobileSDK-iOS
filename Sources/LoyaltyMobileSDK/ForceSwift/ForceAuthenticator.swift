/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public protocol ForceAuthenticator {
    
    var accessToken: String? { get set }
    //var refreshToken: String? { get set }
    
    func grantAccessToken() async throws -> String
    //func grantNewAccessToken(refreshToken: String) async throws -> String
}
