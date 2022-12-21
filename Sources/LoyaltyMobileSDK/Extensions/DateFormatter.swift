//
//  DateFormatter.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/28/22.
//

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
