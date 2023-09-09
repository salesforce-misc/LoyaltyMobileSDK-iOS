//
//  ReceiptListViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 23/07/23.
//

import Foundation
import LoyaltyMobileSDK

enum SortOrder: String {
	case ASC
	case DESC
}

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
	let queryFields = ["Id",
					   "Purchase_Date__c",
					   "ReceiptId__c",
					   "Name",
					   "Status__c",
					   "StoreName__c",
					   "Total_Points__c",
					   "CreatedDate",
					   "TotalAmount__c",
					   "Processed_AWS_Response__c"]
	let recordName = "Receipts__c"
	let orderByField = "CreatedDate"
	let sortOrder = SortOrder.DESC
	private let authManager: ForceAuthenticator
	private var forceClient: ForceClient
	private let localFileManager: FileManagerProtocol
	private let receiptsListFolderName = "ReceiptsList"
	
	init(
		localFileManager: FileManagerProtocol = LocalFileManager.instance,
		authManager: ForceAuthenticator = ForceAuthManager.shared,
		forceClient: ForceClient? = nil
	) {
		self.localFileManager = localFileManager
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
	}
	
	func filter(query: String) {
		filteredReceipts = query.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty ? receipts : receipts.filter { $0.receiptId.contains(query) }
	}
	
	func getQuery() -> String {
		"select \(queryFields.joined(separator: ",")) from \(recordName) Order by \(orderByField) \(sortOrder.rawValue)"
	}
	
	func getReceipts(membershipNumber: String, forced: Bool = false) async throws {
		defer {
			isLoading = false
		}
		guard receipts.isEmpty || forced else { return }
		isLoading = true
		
		if !forced, let cached = LocalFileManager.instance.getData(type: [Receipt].self, id: membershipNumber, folderName: receiptsListFolderName) {
			receipts = cached
		} else {
			do {
				let queryResult = try await forceClient.SOQL(type: Receipt.self, for: getQuery())
				receipts = queryResult.records
				localFileManager.saveData(item: receipts, id: membershipNumber, folderName: receiptsListFolderName, expiry: .never)
			} catch {
				Logger.error(error.localizedDescription)
				throw error
			}
		}
	}
}
