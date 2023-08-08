//
//  ProcessedReceiptItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation

struct ProcessedReceiptItem: Identifiable, Hashable {
	var id = UUID()
	let itemName: String
	let quantity: Int
	let price: Double
	let total: Double
}
