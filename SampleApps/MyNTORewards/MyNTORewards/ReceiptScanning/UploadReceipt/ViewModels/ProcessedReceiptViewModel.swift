//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation

class ProcessedReceiptViewModel: ObservableObject {
	@Published var processedListItems = [ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599),
							  ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599)]
	
	@Published var processedAwsResponse: ProcessedAwsResponse?
	
	final func getProcessedReceiptItems(from receipt: Receipt) throws {
		let processedResponseString = receipt.processedAwsReceipt
		if let processedResponseData = processedResponseString?.data(using: .utf8) {
			processedAwsResponse = try JSONDecoder().decode(ProcessedAwsResponse.self, from: processedResponseData)
		}
	}
	
	final func getProcessedReceiptItems() -> ProcessedAwsResponse {
		return ProcessedAwsResponse(totalAmount: "$1568",
									storeName: "East Repair Inc",
									storeAddress: "",
									receiptNumber: "US-001",
									receiptDate: "11/02/2019",
									memberShipNumber: "435234534",
									lineItem: [LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
												LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
												LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
												LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
												LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
												LineItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599")
											   ])
	}
	
}
