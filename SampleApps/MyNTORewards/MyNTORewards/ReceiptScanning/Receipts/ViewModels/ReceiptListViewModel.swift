//
//  ReceiptListViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class ReceiptListViewModel: ObservableObject {
	@Published var receipts: [Receipt] = []
	@Published var filteredReceipts: [Receipt] = []
	@Published var isLoading = false
	@Published var searchText: String = "" {
		didSet {
			filter(query: searchText)
		}
	}
	
	private let receipts_query = "select Id,Purchase_Date__c,ReceiptId__c,Name,Status__c,StoreName__c,Total_Points__c,CreatedDate,TotalAmount__c from Receipts__c Order by CreatedDate DESC"
	private let authManager: ForceAuthManager
	private var forceClient: ForceClient
	
	init(
		authManager: ForceAuthManager = .shared,
		forceClient: ForceClient? = nil
	) {
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
	}
	
	func filter(query: String) {
		filteredReceipts = query.isEmpty ? receipts : receipts.filter { $0.receiptId.contains(query) }
	}
	
	func getReceipts() async throws {
		defer {
			isLoading = false
		}
		isLoading = true
		do {
			let queryResult = try await forceClient.SOQL(type: Receipt.self, for: receipts_query)
			receipts = queryResult.records
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
}
