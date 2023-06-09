//
//  Date+Extensions.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/4/22.
//

import Foundation

/**
 Helper NSDate extension.
 */
public extension Date {

  // Checks if the date is in the past.
  var inThePast: Bool {
    return timeIntervalSinceNow < 0
  }
}
