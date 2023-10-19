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
		receipts = [
			Receipt(id: "fAkEiD8768712ID1", receiptId: "10123", name: "R0001", status: "Pending", storeName: "Nike", purchaseDate: Date(), totalAmount: "5000.0", totalPoints: nil, createdDate: "2023-08-11T01:47:37.000+0000", imageUrl: "", processedAwsReceipt: "{\n  \"storeName\" : \"East Repair Inc.\",\n  \"storeAddress\" : \"1912 Harvest Lane\\nNew York, NY 12210\",\n  \"receiptNumber\" : \"US-001\",\n  \"receiptDate\" : \"11/02/2019\",\n  \"memberShipNumber\" : \"24345678\",\n  \"lineItem\" : [ {\n    \"quantity\" : \"1\",\n    \"productName\" : \"Front and rear brake cables\",\n    \"price\" : \"100.00\",\n    \"lineItemPrice\" : \"100.00\",\n    \"isEligible\" : true\n  }, {\n    \"quantity\" : \"2\",\n    \"productName\" : \"New set of pedal arms\",\n    \"price\" : \"15.00\",\n    \"lineItemPrice\" : \"30.00\",\n    \"isEligible\" : true\n  }, {\n    \"quantity\" : \"3\",\n    \"productName\" : \"Labor 3hrs\",\n    \"price\" : \"5.00\",\n    \"lineItemPrice\" : \"15.00\",\n    \"isEligible\" : false\n  } ],\n  \"dateFormat\" : \"DD/MM/YYYY\"\n}"),
			Receipt(id: "fAkEiD8745612ID2", receiptId: "10177", name: "R0004", status: "Pending", storeName: "Adidas", purchaseDate: Date(), totalAmount: "7000.0", totalPoints: nil, createdDate: "2023-08-12T01:47:37.000+0000", imageUrl: "", processedAwsReceipt: "{\n  \"storeName\" : \"East Repair Inc.\",\n  \"storeAddress\" : \"1912 Harvest Lane\\nNew York, NY 12210\",\n  \"receiptNumber\" : \"US-002\",\n  \"receiptDate\" : \"11/02/2019\",\n  \"memberShipNumber\" : \"24345678\",\n  \"lineItem\" : [ {\n    \"quantity\" : \"1\",\n    \"productName\" : \"Front and rear brake cables\",\n    \"price\" : \"100.00\",\n    \"lineItemPrice\" : \"100.00\",\n    \"isEligible\" : true\n  }, {\n    \"quantity\" : \"2\",\n    \"productName\" : \"New set of pedal arms\",\n    \"price\" : \"15.00\",\n    \"lineItemPrice\" : \"30.00\",\n    \"isEligible\" : true\n  }, {\n    \"quantity\" : \"3\",\n    \"productName\" : \"Labor 3hrs\",\n    \"price\" : \"5.00\",\n    \"lineItemPrice\" : \"15.00\",\n    \"isEligible\" : false\n  } ],\n  \"dateFormat\" : \"DD/MM/YYYY\"\n}")
		]
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
