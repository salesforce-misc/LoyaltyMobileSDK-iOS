//
//  ReceiptListViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation

class ReceiptListViewModel: ObservableObject {
	var receipts: [Receipt] = [
		Receipt(receiptNumber: "315188", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "346555", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "345346", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "453634", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "985676", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "674577", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "354646", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "674567", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "345656", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$"),
		Receipt(receiptNumber: "567567", receiptDate: "21/03/2023", amount: 200, points: 100, currency: "$")
	]
	
	@Published var filteredReceipts: [Receipt] = []
	@Published var searchText: String = "" {
		didSet {
			print("\(searchText)")
			filter(query: searchText)
		}
	}
	
	func filter(query: String) {
		print("query: \(query)")
		if query.isEmpty {
			filteredReceipts = receipts
			print("query is emty: \(filteredReceipts)")
		} else {
			filteredReceipts = receipts.filter { $0.receiptNumber.contains(query) }
			print("query is not emty: \(filteredReceipts)")
		}
		
	}
}
