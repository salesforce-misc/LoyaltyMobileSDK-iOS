/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import LoyaltyMobileSDK

final class CommonErrorTests: XCTestCase {

    func testForceError() {
        XCTAssertEqual(CommonError.invalidData.description, "Invalid Data Error")
        XCTAssertEqual(CommonError.authenticationNeeded.description, "Authentication is need.")
        XCTAssertEqual(CommonError.userIdentityUnknown.description, "User Identity has not been set.")
        XCTAssertEqual(CommonError.authNotFoundInKeychain.description, "Cannot find the auth from Keychain.")
        XCTAssertEqual(CommonError.requestFailed(message: "failed").description, "Request Failed Error -> failed")
        XCTAssertEqual(CommonError.responseUnsuccessful(message: "failed").description, "Response Unsuccessful Error -> failed")
        XCTAssertEqual(CommonError.jsonConversionFailure(message: "failed").description, "JSON Conversion Failure -> failed")
        XCTAssertEqual(CommonError.authenticationFailed.description, "Authentication failed.")
        XCTAssertEqual(CommonError.codeCredentials.description, "Authorization code and credentials flow failed.")
        XCTAssertEqual(CommonError.functionalityNotEnabled.description, "Functionality is not enabled.")
    }
    
    func testForceErrorDescriptions() {
        XCTAssertEqual(CommonError.invalidData.errorDescription, "Invalid Data Error")
        XCTAssertEqual(CommonError.authenticationNeeded.errorDescription, "Authentication is need.")
        XCTAssertEqual(CommonError.userIdentityUnknown.errorDescription, "User Identity has not been set.")
        XCTAssertEqual(CommonError.authNotFoundInKeychain.errorDescription, "Cannot find the auth from Keychain.")
        XCTAssertEqual(CommonError.requestFailed(message: "failed").errorDescription, "Request Failed Error -> failed")
        XCTAssertEqual(CommonError.responseUnsuccessful(message: "failed").errorDescription, "Response Unsuccessful Error -> failed")
        XCTAssertEqual(CommonError.jsonConversionFailure(message: "failed").errorDescription, "JSON Conversion Failure -> failed")
        XCTAssertEqual(CommonError.authenticationFailed.errorDescription, "Authentication failed.")
        XCTAssertEqual(CommonError.codeCredentials.errorDescription, "Authorization code and credentials flow failed.")
        XCTAssertEqual(CommonError.functionalityNotEnabled.errorDescription, "Functionality is not enabled.")
    }

}
