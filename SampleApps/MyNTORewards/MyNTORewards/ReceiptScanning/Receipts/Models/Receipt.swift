//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

struct Receipt: Identifiable, Codable, Equatable {
	let id: String
	let receiptId: String?
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
		case id
		case receiptId
		case name
		case status
		case storeName
		case purchaseDate
		case totalAmount
		case totalPoints
		case createdDate
		case imageUrl
		case processedAwsReceipt
		
		var rawValue: String {
			switch self {
			case .id:
				return "Id"
			case .receiptId:
				return "\(StringConstants.Receipts.namespace)__ReceiptID__c"
			case .name:
				return "Name"
			case .status:
				return "\(StringConstants.Receipts.namespace)__Status__c"
			case .storeName:
				return "\(StringConstants.Receipts.namespace)__StoreName__c"
			case .purchaseDate:
				return "\(StringConstants.Receipts.namespace)__PurchaseDate__c"
			case .totalAmount:
				return "\(StringConstants.Receipts.namespace)__TotalAmount__c"
			case .totalPoints:
				return "\(StringConstants.Receipts.namespace)__TotalRewardPoints__c"
			case .createdDate:
				return "CreatedDate"
			case .imageUrl:
				return "\(StringConstants.Receipts.namespace)__ImageUrl__c"
			case .processedAwsReceipt:
				return "\(StringConstants.Receipts.namespace)__APIResponse__c"
			}
		}
	}
}

enum ReceiptState {
	case processing
	case processed
	case submitted(Double?)
}
