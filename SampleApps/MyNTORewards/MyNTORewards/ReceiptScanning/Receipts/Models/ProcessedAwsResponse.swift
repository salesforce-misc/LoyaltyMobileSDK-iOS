//
//  ProcessedAwsResponse.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 05/09/23.
//

import Foundation

struct ProcessedAwsResponse: Decodable {
	let totalAmount: String
	let storeName: String
	let storeAddress: String
	let receiptNumber: String
	let receiptDate: String
	let memberShipNumber: String
	let lineItem: [ProcessedReceiptItem]
}

//struct LineItem: Decodable, Hashable {
//	let quantity: String
//	let productName: String
//	let price: String
//	let lineItemPrice: String
//}
