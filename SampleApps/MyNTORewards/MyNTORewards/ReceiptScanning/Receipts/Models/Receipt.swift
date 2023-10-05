//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

struct Receipt: Identifiable, Codable, Equatable {
	let id: String
	let receiptId: String
	let name: String
	let status: String
	let storeName: String
	let purchaseDate: Date?
	let totalAmount: String?
	let totalPoints: Double?
	let createdDate: String
	let imageUrl: String?
	let processedAwsReceipt: String?
	
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case receiptId = "ReceiptID__c"
		case name = "Name"
		case status = "Status__c"
		case storeName = "StoreName__c"
		case purchaseDate = "PurchaseDate__c"
		case totalAmount = "TotalAmount__c"
		case totalPoints = "TotalRewardPoints__c"
		case createdDate = "CreatedDate"
		case imageUrl = "ImageUrl__c"
		case processedAwsReceipt = "APIResponse__c"
	}
}

enum ReceiptState {
	case processing
	case processed
	case submitted(Double?)
}
