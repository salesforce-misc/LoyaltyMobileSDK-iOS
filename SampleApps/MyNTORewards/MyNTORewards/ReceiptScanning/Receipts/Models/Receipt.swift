//
//  Receipt.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

class Receipt: Identifiable, Codable {
	var id: String?
	var receiptId: String?
	var name: String?
	var status: String?
	var storeName: String?
	var purchaseDate: String?
	var totalAmount: String?
	var totalPoints: String?
	var createdDate: String?
	var processedAwsReceipt: String?
	
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
		case processedAwsReceipt = "Processed_AWS_Response__c"
	}
}

enum ReceiptState {
	case processing
	case processed
	case submitted
}
