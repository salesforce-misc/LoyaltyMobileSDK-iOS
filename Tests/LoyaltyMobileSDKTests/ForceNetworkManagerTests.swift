/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import LoyaltyMobileSDK

final class ForceNetworkManagerTests: XCTestCase {
    let forceNetworkManager = NetworkManager.shared
    
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
    
    func testHandleDataAndResponse() async throws {
        let data = try XCTestCase.load(resource: "Promotions")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let output = try await mockSession.data(for: getMockRequest())
        let outputData = try forceNetworkManager.handleDataAndResponse(output: output)
        let promotions = try JSONDecoder().decode(PromotionModel.self, from: outputData)
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
    }
    
    func testHandleUnauthResponse() async throws {
        let data = try XCTestCase.load(resource: "Promotions")
        var mockSession = URLSession.mock(responseBody: data, statusCode: 401)
        var output = try await mockSession.data(for: getMockRequest())
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            XCTAssertEqual(error as! CommonError, CommonError.authenticationNeeded)
        }
        
        mockSession = URLSession.mock(responseBody: data, statusCode: 403)
        output = try await mockSession.data(for: getMockRequest())
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            XCTAssertEqual(error as! CommonError, CommonError.functionalityNotEnabled)
        }
        
        mockSession = URLSession.mock(responseBody: data, statusCode: 405)
        output = try await mockSession.data(for: getMockRequest())
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            XCTAssertEqual(error as! CommonError, CommonError.responseUnsuccessful(message: "HTTP response status code 405"))
        }
        
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            XCTAssertEqual(error as! CommonError, CommonError.responseUnsuccessful(message: "HTTP response status code 405"))
        }
    }
    
    func testFetch() async throws {
        let data = try XCTestCase.load(resource: "Promotions")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let promotions = try await forceNetworkManager.fetch(type: PromotionModel.self, request: getMockRequest(), urlSession: mockSession)
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
        let mockSession1 = URLSession.mock(responseBody: data, statusCode: 401)
        
        // Handle authentication failed scenrio
        do {
            _ = try await forceNetworkManager.fetch(type: PromotionModel.self, request: getMockRequest(), urlSession: mockSession1)
            XCTAssertEqual(promotions.status, true)
        } catch {
            XCTAssertEqual(error as! CommonError, CommonError.authenticationNeeded)
        }
        
        let mockSession2 = URLSession.mock(responseBody: data, statusCode: 201)
        // Handle authentication failed scenrio
        do {
            _ = try await forceNetworkManager.fetch(type: PromotionModel.self, request: getMockRequest(), urlSession: mockSession2)
            XCTAssertEqual(promotions.status, true)
        } catch {
            XCTAssertEqual(error as! CommonError, CommonError.authenticationNeeded)
        }
    }
    
}
