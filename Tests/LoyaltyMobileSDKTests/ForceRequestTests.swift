/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import LoyaltyMobileSDK

final class ForceRequestTests: XCTestCase {
    
    func testCreateUrl() async {
        guard let sampleUrl = URL(string: "https://instanceUrl") else {
            return
        }
        do {
            let queryItems = [
                "username": "testUsername",
                "password": "testpassword",
                "grant_type": "testpassword",
                "client_id": "testconsumerKey",
                "client_secret": "testconsumerSecret"
            ]
            
            let request = try ForceRequest.create(url: sampleUrl, method: "POST", queryItems: queryItems)
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(request.timeoutInterval, 60.0)
            
        } catch { }
    }
    
    func testCreateMethod() async {
        do {
            var request = try ForceRequest.create(instanceURL: "https://instanceUrl", path: "connect/loyalty/member/1234/memberbenefits", method: "GET")
            
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.timeoutInterval, 60.0)
            
            request = try ForceRequest.create(instanceURL: "https:\\instanceUrl", path: "connect/loyalty/member/1234/memberbenefits", method: "GET")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testSetAuthorization() async throws {
        let request = try ForceRequest.create(instanceURL: "https://instanceUrl", path: "connect/loyalty/member/1234/memberbenefits", method: "GET")
        let requestWithAuth = ForceRequest.setAuthorization(request: request, accessToken: "A1234SN")
        XCTAssertEqual(requestWithAuth.allHTTPHeaderFields?["Authorization"], "Bearer A1234SN")
    }
}
