//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

struct Receipt: Identifiable, Codable {
	let id: String
	let receiptId: String
	let name: String
	let status: String
	let storeName: String
	let purchaseDate: Date
	let totalAmount: String?
	let totalPoints: String?
	let createdDate: Date
	
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case receiptId = "ReceiptId__c"
		case name = "Name"
		case status = "Status__c"
		case storeName = "StoreName__c"
		case purchaseDate = "Purchase_Date__c"
		case totalAmount = "TotalAmount__c"
		case totalPoints = "Total_Points__c"
		case createdDate = "CreatedDate"
	}
}

enum ReceiptState {
	case processing
	case processed
	case submitted
}
