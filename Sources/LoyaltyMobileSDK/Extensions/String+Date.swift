//
//  String+Date.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/23/22.
//

import Foundation

public extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

public extension Date {

    func toString(withFormat format: String = "dd MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: self)
        return string
    }
}

public extension Date {

    var monthBefore: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
}
