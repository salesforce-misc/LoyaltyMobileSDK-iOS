/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// An extension of DateFormatter to provide custom date formats for the Salesforce API.
extension DateFormatter {
    
    /// Enumeration for representing the length of the date format.
    enum Length: String, CaseIterable {
        case short = "yyyy-MM-dd"
        case long = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        case medium = "yyyy-MM-dd'T'HH:mm:ss"
        case standard = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    /// Creates a DateFormatter instance with a specified date format length.
    /// - Parameter length: The `Length` of the date format (defaults to `.standard`).
    /// - Returns: A DateFormatter instance with the specified date format length.
    static func forceFormatter(_ length: Length = .standard) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = length.rawValue
        return formatter
    }
    
    /// Returns a DateFormatter array of all possible `Length` cases.
    /// - Returns: A arrary of `DateFormatter` instance with the specified date format length.
    static func forceFormatters() -> [DateFormatter] {
        return Length.allCases.map { forceFormatter($0) }
    }
}
