/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// https://www.avanderlee.com/swift/url-components/
public extension Collection where Element == URLQueryItem {
    
    subscript(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}
