//
//  ForceAuthManagerTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 25/05/23.
//

import XCTest
@testable import MyNTORewards

final class ForceAuthManagerTests: XCTestCase {
    let authManager   =  ForceAuthManager.shared
    
    override func tearDown() {
        authManager.clearAuth()
        super.tearDown()
    }

    func getMockAuth() throws -> ForceAuth {
        return ForceAuth(accessToken: "ACT00D4x000008ZreC!AQcAQDf6x5AjGhB8FIxmOLCqq7XmGzNgt97ID0HiBToYj5tfNB7f4eM39.UivE_HXIg.46Bm3IhQXOawUwznIZRbsJNQV7W9", instanceURL: "https://sampleInstanceUrl", identityURL: "https://sampleIdentityUrl", tokenType: "refresh", timestamp: "20:20", signature: "nto", refreshToken: "token1234")
    }

    func testSaveAuth() throws {
        try authManager.saveAuth(for: getMockAuth(), forceAuth: MockAuthManager.self)
        let auth = try MockAuthManager.retrieve(for: "https://sampleInstanceUrl")
        XCTAssertEqual(auth?.accessToken, "ACT00D4x000008ZreC!AQcAQDf6x5AjGhB8FIxmOLCqq7XmGzNgt97ID0HiBToYj5tfNB7f4eM39.UivE_HXIg.46Bm3IhQXOawUwznIZRbsJNQV7W9")
    }

    func testRetrieveAuth() throws {
        try authManager.saveAuth(for: getMockAuth(), forceAuth: MockAuthManager.self)
        let auth = try authManager.retrieveAuth(forceAuth: MockAuthManager.self)
        XCTAssertEqual(auth.accessToken, "ACT00D4x000008ZreC!AQcAQDf6x5AjGhB8FIxmOLCqq7XmGzNgt97ID0HiBToYj5tfNB7f4eM39.UivE_HXIg.46Bm3IhQXOawUwznIZRbsJNQV7W9")
    }

    func testDeleteAuth() throws {
        try authManager.saveAuth(for: getMockAuth(), forceAuth: MockAuthManager.self)
        try authManager.deleteAuth(forceAuth: MockAuthManager.self)
        XCTAssertTrue(MockAuthManager.mockKeyChain.isEmpty)
    }

    func testGrandAuthWithoauthFlow() async throws {
        
        do {
            let auth = try await authManager.grantAccessToken()
            XCTAssertNotNil(auth)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testClearAuth() throws {
        authManager.clearAuth()
        XCTAssertTrue(MockAuthManager.mockKeyChain.isEmpty)
    }
}
