//
//  TestDataStore.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 11/05/23.
//

import Foundation

enum TestDataError: Error {
	case incorrectData(_ message: String)
}

final class TestDataStore {
	public static let shared = TestDataStore()
	private init() { }
	
	func getUsername() throws -> String {
		guard let username = getValue(for: "TEST_USERNAME") as? String
		else {
			throw TestDataError.incorrectData("test data error: username")
		}
		return username
	}
	
	func getPassword() throws -> String {
		guard let password = getValue(for: "TEST_PASSWORD") as? String
		else {
			throw TestDataError.incorrectData("test data error: password")
		}
		return password
	}
	
	private func getValue(for key: String) -> Any? {
		return Bundle(for: MyNTORewardsTests.self).object(forInfoDictionaryKey: key)
	}
}
