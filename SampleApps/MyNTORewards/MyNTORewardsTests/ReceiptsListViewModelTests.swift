//
//  ReceiptsListViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 18/08/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class ReceiptsListViewModelTests: XCTestCase {

	var viewModel: ReceiptListViewModel!
	var receipts: [Receipt] = []
	
	@MainActor override func setUp() {
		super.setUp()
		let mockAuthenticator = MockAuthenticator.sharedMock
		viewModel = ReceiptListViewModel(localFileManager: MockFileManager.mockInstance, authManager: mockAuthenticator)
//		receipts = [
//			Receipt(id: "fAkEiD8768712ID1", receiptId: "10123", name: "R0001", status: "Pending", storeName: "Nike", purchaseDate: "2023-08-01T19:00:00.000+0000", totalAmount: 5000.0, totalPoints: nil, createdDate: "2023-08-11T01:47:37.000+0000"),
//			Receipt(id: "fAkEiD8745612ID2", receiptId: "10177", name: "R0004", status: "Pending", storeName: "Adidas", purchaseDate: "2023-08-02T19:00:00.000+0000", totalAmount: 7000.0, totalPoints: nil, createdDate: "2023-08-12T01:47:37.000+0000")
//		]
                receipts = []
		viewModel.receipts = receipts
    }

    override func tearDown() {
        viewModel = nil
    }
	
	@MainActor func test_filterReceipts_matchingQueryShouldReturnOnlyMatchingReceipts() {
		viewModel.searchText = "1017"
		XCTAssertEqual(viewModel.filteredReceipts[0].id, receipts[1].id)
		XCTAssertNotEqual(viewModel.filteredReceipts.count, receipts.count)
	}
	
	@MainActor func test_filterReceipts_emptySpaceShouldReturnAllReceipts() {
		viewModel.searchText = ""
		XCTAssertEqual(viewModel.filteredReceipts.count, 2)
	}
	
	@MainActor func test_filterReceipts_notMatchingQueryShouldReturnNoReceipts() {
		viewModel.searchText = "55555"
		XCTAssertTrue(viewModel.filteredReceipts.isEmpty)
	}

}
