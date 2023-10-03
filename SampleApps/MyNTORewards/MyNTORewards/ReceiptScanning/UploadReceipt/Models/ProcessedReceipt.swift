//
//  ProcessedReceiptItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation

// MARK: - ProcessedReceipt
struct ProcessedReceipt: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
	let receiptSFDCId: String?
    let totalAmount: String?
    let storeName: String
    let storeAddress: String
    let receiptNumber: String
    let receiptDate: Date
    let lineItem: [ProcessedReceiptItem]
    
	init(
		receiptSfdcId: String?,
		totalAmount: String?,
		storeName: String,
		storeAddress: String,
		receiptNumber: String,
		receiptDate: Date,
		lineItem: [ProcessedReceiptItem]) {
		self.receiptSFDCId = receiptSfdcId
		self.totalAmount = totalAmount
		self.storeName = storeName
		self.storeAddress = storeAddress
		self.receiptNumber = receiptNumber
		self.receiptDate = receiptDate
		self.lineItem = lineItem
	}
}

// MARK: - ProcessedReceiptItem
struct ProcessedReceiptItem: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
    let quantity: String
    let productName: String
    let price: String?
    let lineItemPrice: String?
	let isEligible: Bool
    
	init(quantity: String, productName: String, price: String?, lineItemPrice: String?, isEligible: Bool) {
        self.quantity = quantity
        self.productName = productName
        self.price = price
        self.lineItemPrice = lineItemPrice
		self.isEligible = isEligible
    }
}
