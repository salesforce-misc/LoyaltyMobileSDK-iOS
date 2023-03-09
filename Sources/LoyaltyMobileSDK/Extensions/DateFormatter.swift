/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public extension DateFormatter {
    
    enum Length: String {
        case short = "yyyy-MM-dd"
        case long = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        case middle = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    static func forceFormatter(_ length: Length = .middle) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = length.rawValue
        return formatter
    }
}
