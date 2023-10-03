//
//  Double+round.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 26/07/23.
//

import Foundation

extension Double {
	/// Rounds the double to decimal places value
	func rounded(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
	
	func truncate(to places: Int) -> String {
		return String(format: "%.\(places)f", self)
	}
}
