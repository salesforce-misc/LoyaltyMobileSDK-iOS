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
}
