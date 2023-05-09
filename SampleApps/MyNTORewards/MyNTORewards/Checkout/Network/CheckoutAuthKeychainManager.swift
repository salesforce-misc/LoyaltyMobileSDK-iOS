//
//  CheckoutKeychainManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation

struct CheckoutAuthKeychainManager {
	
	static let serviceId: String = AppSettings.Defaults.keychainAuthServiceId
	
	static func save(item auth: CheckoutAuth) throws {
		let data = try JSONEncoder().encode(auth)
		try Keychain.write(data: data, service: serviceId, account: auth.identityURL)
	}
	
	static func retrieve(for identityURL: String) throws -> CheckoutAuth? {
		do {
			let data = try Keychain.read(service: serviceId, account: identityURL)
			return try JSONDecoder().decode(CheckoutAuth.self, from: data)
		} catch {
			if case Keychain.KeychainError.itemNotFound = error {
				return nil
			} else {
				throw error
			}
		}
	}
	
}
