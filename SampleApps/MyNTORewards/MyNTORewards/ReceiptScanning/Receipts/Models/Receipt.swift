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
		case receiptId = "pppos123__ReceiptID__c"
		case name = "Name"
		case status = "pppos123__Status__c"
		case storeName = "pppos123__StoreName__c"
		case purchaseDate = "pppos123__PurchaseDate__c"
		case totalAmount = "pppos123__TotalAmount__c"
		case totalPoints = "pppos123__TotalRewardPoints__c"
		case createdDate = "CreatedDate"
		case imageUrl = "pppos123__ImageUrl__c"
		case processedAwsReceipt = "pppos123__APIResponse__c"
	}
}

enum ReceiptState {
	case processing
	case processed
	case submitted(Double?)
}
