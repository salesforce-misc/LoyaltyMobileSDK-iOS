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
	private let localFileManager: FileManagerProtocol
	private let receiptsListFolderName = "ReceiptsList"
	
	init(localFileManager: FileManagerProtocol = LocalFileManager.instance,
		authManager: ForceAuthManager = .shared,
		forceClient: ForceClient? = nil
	) {
		self.localFileManager = localFileManager
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
	}
	
	func filter(query: String) {
		filteredReceipts = query.isEmpty ? receipts : receipts.filter { $0.receiptId.contains(query) }
	}
	
	func getReceipts(membershipNumber: String, forced: Bool = false) async throws {
		defer {
			isLoading = false
		}
		isLoading = true
		if !forced, let cached = LocalFileManager.instance.getData(type: [Receipt].self, id: membershipNumber, folderName: receiptsListFolderName) {
			receipts = cached
		} else {
			do {
				let queryResult = try await forceClient.SOQL(type: Receipt.self, for: receipts_query)
				receipts = queryResult.records
				localFileManager.saveData(item: receipts, id: membershipNumber, folderName: receiptsListFolderName, expiry: .never)
			} catch {
				Logger.error(error.localizedDescription)
				throw error
			}
		}
	}
}
