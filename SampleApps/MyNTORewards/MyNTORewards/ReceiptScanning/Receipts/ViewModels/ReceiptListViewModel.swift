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
	
	private let authManager: ForceAuthenticator
	private var forceClient: ForceClient
	private let localFileManager: FileManagerProtocol
	private let soqlManager: SOQLManager
	private let receiptsListFolderName = "ReceiptsList"
	
	init(
		localFileManager: FileManagerProtocol = LocalFileManager.instance,
		authManager: ForceAuthenticator = ForceAuthManager.shared,
		forceClient: ForceClient? = nil,
		soqlManager: SOQLManager? = nil
	) {
		self.localFileManager = localFileManager
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
		self.soqlManager = soqlManager ?? SOQLManager(forceClient: self.forceClient)
	}
	
	private func filter(query: String) {
		let trimmedQuery = query.trimmingCharacters(in: CharacterSet(charactersIn: " "))
		filteredReceipts = trimmedQuery.isEmpty 
            ? receipts
            : receipts.filter {
                $0.processedAwsReceipt?.lowercased().contains(trimmedQuery.lowercased()) ?? false
            }
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
		guard receipts.isEmpty || forced else { return }
		if !forced, let cached = LocalFileManager.instance.getData(type: [Receipt].self, id: membershipNumber, folderName: receiptsListFolderName) {
			setReceipts(receipts: cached)
		} else {
			do {
				let receipts = try await soqlManager.getReceipts(membershipNumber: membershipNumber)
				setReceipts(receipts: receipts)
				localFileManager.saveData(item: receipts, id: membershipNumber, folderName: receiptsListFolderName, expiry: .never)
			} catch {
				Logger.error(error.localizedDescription)
				throw error
			}
		}
	}
}
