//
//  Reloadable.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/05/23.
//

import Foundation

protocol Reloadable {
	func reload(id: String, number: String) async throws
}
