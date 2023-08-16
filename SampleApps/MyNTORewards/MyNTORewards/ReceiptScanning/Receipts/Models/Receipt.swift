//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

struct Receipt: Identifiable, Decodable {
	let id: String
	let receiptId: String
	let name: String
	let status: String
	let storeName: String
	let purchaseDate: String
	let totalAmount: Double
	let totalPoints: Double?
	let createdDate: String
	
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
