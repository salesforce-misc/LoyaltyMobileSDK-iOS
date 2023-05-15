/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import LoyaltyMobileSDK

final class ForceClientTests: XCTestCase {
    private var forceClient: ForceClient!

    override func setUp() {
        forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: MockNetworkManager.sharedMock)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        forceClient = nil
    }
    
    func getMockRequest() async throws -> URLRequest {
        let requestBody: [String: Any] = [
            "processParameters": [
                ["MemberId": "1234"]
            ]
        ]
        let path = "connect/loyalty/member/\(1234)/memberbenefits"
        let bodyJsonData = try JSONSerialization.data(withJSONObject: requestBody)
        let request = try ForceRequest.create(instanceURL: "https://instanceUrl", path: path, method: "POST", body: bodyJsonData)
        return request
    }
    
    func testFetchLocalJson() async throws {
        let result = try forceClient.fetchLocalJson(type: PromotionModel.self, file: "Promotions", bundle: Bundle.module)
        XCTAssertEqual(result.status, true)
        XCTAssertEqual(result.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(result.message)
        
        do {
            _ = try forceClient.fetchLocalJson(type: PromotionModel.self, file: "Promotions", bundle: Bundle.main)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testFetch() async throws {
        let data = try XCTestCase.load(resource: "Promotions")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let promotions = try await forceClient.fetch(type: PromotionModel.self, with: getMockRequest(), urlSession: mockSession)
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
        
        MockAuthenticator.sharedMock.needToThrowError = true
        // Handle authentication failed scenrio
        do {
            let promotionsWithAuthFlow = try await forceClient.fetch(type: PromotionModel.self, with: getMockRequest(), urlSession: mockSession)
            XCTAssertEqual(promotionsWithAuthFlow.status, true)
        } catch {
            XCTAssertEqual(error as! CommonError, CommonError.authenticationNeeded)
        }
        
        MockAuthenticator.sharedMock.needToThrowError = false
        
        MockNetworkManager.sharedMock.statusCode = 401
        var mockSessionWithError = URLSession.mock(responseBody: data, statusCode: 401)
        // Handle authentication failed scenrio
        do {
            let promotionsWithAuthFlow = try await forceClient.fetch(type: PromotionModel.self, with: getMockRequest(), urlSession: mockSessionWithError)
            XCTAssertEqual(promotionsWithAuthFlow.status, true)
        } catch {
            XCTAssertEqual(error as! CommonError, CommonError.authenticationNeeded)
        }
        
        MockNetworkManager.sharedMock.statusCode = 403
        mockSessionWithError = URLSession.mock(responseBody: data, statusCode: 403)
        // Handle other error failed scenrio
        do {
            let promotionsWithAuthFlow = try await forceClient.fetch(type: PromotionModel.self, with: getMockRequest(), urlSession: mockSessionWithError)
            XCTAssertEqual(promotionsWithAuthFlow.status, true)
        } catch {
            XCTAssertEqual(error as! CommonError, CommonError.functionalityNotEnabled)
        }

    }
}
