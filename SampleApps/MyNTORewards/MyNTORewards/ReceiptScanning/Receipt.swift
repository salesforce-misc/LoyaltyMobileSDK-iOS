//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

struct Receipt: Identifiable {
	let id = UUID()
	let receiptNumber: String
	let receiptDate: String
	let amount: Int
	let points: Int
	let currency: String
}
