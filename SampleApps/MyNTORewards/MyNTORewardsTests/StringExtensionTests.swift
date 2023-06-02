//
//  StringExtensionTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 22/05/23.
//

import XCTest
@testable import MyNTORewards

final class StringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testToDate() {
        let activityDate = "2023-04-08T04:59:40.000Z"
        let date = activityDate.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        XCTAssertEqual(date?.toString() ?? "", "08 April 2023")
    }
    
    func testStringWidth() {
        var width = "Hello World".stringWidth()
        XCTAssertEqual(Int(width), 89)
        width = "Welcome to swift".stringWidth()
        XCTAssertEqual(Int(width), 133)
    }
    
    func testToString() {
        let activityDate = "2023-04-08T04:59:40.000Z"
        let date = activityDate.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let stringDate  = date?.toString() ?? ""
        XCTAssertEqual(stringDate, "08 April 2023")
    }
    
    func testMonthBefore() {
        let oneMonthBefore = Date.init(timeIntervalSinceNow: -(32 * 24 * 60 * 60))
        XCTAssertFalse(oneMonthBefore > Date().monthBefore)
        let twoDaysBefore = Date.init(timeIntervalSinceNow: -(2 * 24 * 60 * 60))
        XCTAssertTrue(twoDaysBefore > Date().monthBefore)
        XCTAssertTrue(twoDaysBefore.inThePast)
    }
}
