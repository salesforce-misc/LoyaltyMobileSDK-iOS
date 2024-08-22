//
//  GamificationMockFileManager.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 12/01/24.
//

import XCTest
@testable import MyNTORewards
@testable import GamificationMobileSDK

class GamificationMockAuthenticator: GamificationForceAuthenticator {
	func getAccessToken() -> String? {
		return "Access1234"
	}
	
	var accessToken: String?
	
	func grantAccessToken() async throws -> String {
		return "Access1234"
	}
	
	static let sharedMock = GamificationMockAuthenticator()
}
