/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// An extension of Collection for handling URLQueryItem objects.
/// This extension simplifies the process of extracting the values of query items from a URL.
/// For more information, visit: https://www.avanderlee.com/swift/url-components/
extension Collection where Element == URLQueryItem {
    
    /// Provides a convenient subscript to access the value of a URLQueryItem by its name.
    /// - Parameter name: The name of the URLQueryItem whose value you want to retrieve.
    /// - Returns: The value of the URLQueryItem as a `String?`, or `nil` if the name is not found in the collection.
    subscript(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}
