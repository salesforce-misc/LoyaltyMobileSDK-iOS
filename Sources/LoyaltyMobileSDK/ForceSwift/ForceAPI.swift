/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public struct ForceAPI {
    
    /// Get API common path
    /// - Parameters:
    ///   - api: The API name
    ///   - version: The API version number
    /// - Returns: The HTTP path can be extended to host
    public static func path(for api: String, version: String) -> String {
        "/services/data/v\(version)/\(api)"
    }
    
}
