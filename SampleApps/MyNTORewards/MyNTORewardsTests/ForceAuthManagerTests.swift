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
        return ForceAuth(accessToken: "DumMYaCceSsTOkEn1234", instanceURL: "https://sampleInstanceUrl", identityURL: "https://sampleIdentityUrl", tokenType: "refresh", timestamp: "20:20", signature: "nto", refreshToken: "token1234")
    }

    func testSaveAuth() throws {
        try authManager.saveAuth(for: getMockAuth(), forceAuth: MockAuthManager.self)
        let auth = try MockAuthManager.retrieve(for: "https://sampleInstanceUrl")
        XCTAssertEqual(auth?.accessToken, "DumMYaCceSsTOkEn1234")
    }

    func testRetrieveAuth() throws {
        try authManager.saveAuth(for: getMockAuth(), forceAuth: MockAuthManager.self)
        let auth = try authManager.retrieveAuth(forceAuth: MockAuthManager.self)
        XCTAssertEqual(auth.accessToken, "DumMYaCceSsTOkEn1234")
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
