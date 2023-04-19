//
//  CommonErrorTests.swift
//  
//
//  Created by Anandhakrishnan Kanagaraj on 02/02/23.
//

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
    }

}
