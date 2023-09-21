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
	@Published var isLoading = true
	@Published var searchText: String = "" {
		didSet {
            if oldValue != searchText {
                filter(query: searchText)
            }
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
					   "ImageUrl__c",
					   "Processed_AWS_Response__c"]
	let recordName = "Receipts__c"
    let whereClause = "Loyalty_Program_Member__r.MembershipNumber"
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
		let trimmedQuery = query.trimmingCharacters(in: CharacterSet(charactersIn: " "))
		filteredReceipts = trimmedQuery.isEmpty ? receipts : receipts.filter { $0.processedAwsReceipt?.lowercased().contains(trimmedQuery.lowercased()) ?? false }
	}
	
    func getQuery(membershipNumber: String) -> String {
		"SELECT \(queryFields.joined(separator: ",")) FROM \(recordName) WHERE \(whereClause) = '\(membershipNumber)' ORDER BY \(orderByField) \(sortOrder.rawValue)"
	}
	
	private func setReceipts(receipts: [Receipt]) {
		self.receipts = receipts
		if searchText.isEmpty {
			self.filteredReceipts = receipts
		} else {
			filter(query: searchText)
		}
	}
	
	func getReceipts(membershipNumber: String, forced: Bool = false) async throws {
		defer {
			isLoading = false
		}
		guard receipts.isEmpty || forced else { return }
		isLoading = true
		
		if !forced, let cached = LocalFileManager.instance.getData(type: [Receipt].self, id: membershipNumber, folderName: receiptsListFolderName) {
			setReceipts(receipts: cached)
		} else {
			do {
				let queryResult = try await forceClient.SOQL(type: Receipt.self, for: getQuery(membershipNumber: membershipNumber))
				setReceipts(receipts: queryResult.records)
				localFileManager.saveData(item: receipts, id: membershipNumber, folderName: receiptsListFolderName, expiry: .never)
			} catch {
				Logger.error(error.localizedDescription)
				throw error
			}
		}
	}
}
