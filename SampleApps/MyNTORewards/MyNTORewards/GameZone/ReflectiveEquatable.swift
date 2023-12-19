//
//  ReflectiveEquatable.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 18/12/23.
//

import Foundation

protocol ReflectiveEquatable: Equatable {}

extension ReflectiveEquatable {
	var reflectedValue: String { String(reflecting: self) }
	
	// Explicitly implement the required `==` function
	// (The compiler will synthesize `!=` for us implicitly)
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.reflectedValue == rhs.reflectedValue
	}
}
