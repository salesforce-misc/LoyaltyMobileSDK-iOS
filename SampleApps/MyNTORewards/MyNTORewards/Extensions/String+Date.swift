/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

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
	
	func toDateString(withFormat format: String = "dd-MM-yyyy") -> String? {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		dateFormatter.dateFormat = format
		let date = dateFormatter.date(from: self)
		return date?.toString(withFormat: format)
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

	func getDate(beforeDays days: Int) -> Date? {
		return Calendar.current.date(byAdding: .day, value: -days, to: self)
	}
	
	func getDays(from currentDate: Date = Date()) -> Int? {
		var calendar = Calendar.current
		calendar.locale = Locale(identifier: "en_US_POSIX")
		if let timeZone = TimeZone(secondsFromGMT: 0) {
			calendar.timeZone = timeZone
		}
		// Using calendar.startOfDay to ignore time and to compare just dates.
		let currentDate = calendar.startOfDay(for: currentDate)
		let expiryDate = calendar.startOfDay(for: self)
		let component = Calendar.current.dateComponents([.day], from: currentDate, to: expiryDate)
		return component.day
	}
}

public extension Date {

    var monthBefore: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
}
