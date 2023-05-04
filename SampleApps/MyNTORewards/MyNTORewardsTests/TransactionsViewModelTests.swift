//
//  TransactionsViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 08/03/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class TransactionsViewModelTests: XCTestCase {
    var viewModel: TransactionViewModel!

    override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = TransactionViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchTransactions() async throws {
        let transactions = try await viewModel.fetchTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(transactions.count == 4)
        XCTAssertTrue(transactions[0].id == "0lVRO00000002og2AA")
        XCTAssertTrue(transactions[1].activityDate == "2023-04-08T04:58:07.000Z")
    }
    
    func testLoadTransactions() async throws {
        await viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertFalse(viewModel.transactions.isEmpty)
        
        ///verify the file storage
        let transactions = MockFileManager.mockInstance.getData(type: [TransactionJournal].self, id: "1234", folderName: "TransactionHistory") ?? []
        XCTAssertTrue(transactions.count == 4)
        
        await viewModel.clear()
        try await viewModel.loadTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertFalse(viewModel.transactions.isEmpty)
        XCTAssertTrue(viewModel.transactions.count == 3)
        XCTAssertTrue(viewModel.transactions[0].id == "0lVRO00000002og2AA")
        XCTAssertTrue(viewModel.transactions[1].activityDate == "2023-04-08T04:58:07.000Z")
    }
    
    func testReloadTransactions() async throws {
        try await viewModel.reloadTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertFalse(viewModel.transactions.isEmpty)
        XCTAssertTrue(viewModel.transactions.count == 3)
        XCTAssertTrue(viewModel.transactions[0].id == "0lVRO00000002og2AA")
        XCTAssertTrue(viewModel.transactions[1].activityDate == "2023-04-08T04:58:07.000Z")
    }
    
    func testReloadAllTransactions() async throws {
        try await viewModel.reloadAllTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.recentTransactions.count == 3)
        XCTAssertTrue(viewModel.recentTransactions[0].id == "0lVRO00000002og2AA")
        XCTAssertTrue(viewModel.recentTransactions[0].journalTypeName == "Manual Points Adjustment")
        XCTAssertTrue(viewModel.olderTransactions.count == 1)
        XCTAssertTrue(viewModel.olderTransactions[0].activityDate == "2022-03-08T04:53:19.000Z")
        XCTAssertTrue(viewModel.olderTransactions[0].id == "0lVRO00000002oR2AQ")
    }
    
    func testLoadAllTransactions() async throws {
        await viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadAllTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.recentTransactions.count == 3)
        XCTAssertTrue(viewModel.recentTransactions[0].id == "0lVRO00000002og2AA")
        XCTAssertTrue(viewModel.recentTransactions[0].journalTypeName == "Manual Points Adjustment")
        XCTAssertTrue(viewModel.olderTransactions.count == 1)
        XCTAssertTrue(viewModel.olderTransactions[0].activityDate == "2022-03-08T04:53:19.000Z")
        XCTAssertTrue(viewModel.olderTransactions[0].id == "0lVRO00000002oR2AQ")
        
        ///verify the file storage
        let transactions = MockFileManager.mockInstance.getData(type: [TransactionJournal].self, id: "1234", folderName: "TransactionHistory") ?? []
        XCTAssertTrue(transactions.count == 4)
        
        await viewModel.clear()
        try await viewModel.loadAllTransactions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.recentTransactions.count == 3)
        XCTAssertTrue(viewModel.olderTransactions.count == 1)
    }

}
