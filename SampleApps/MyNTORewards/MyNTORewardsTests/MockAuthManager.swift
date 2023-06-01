//
//  MockAuthManagerTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 26/05/23.
//

import XCTest
@testable import MyNTORewards

final class MockAuthManager: KeychainManagerProtocol {
    
    typealias T = ForceAuth
    static var mockKeyChain: [String: [String: ForceAuth]] = [:]
    static let serviceId = "LoyaltyMobileSDK.ConnectedApp.unittest"
    
    static func save(item: ForceAuth) throws {
        var keychainValues = mockKeyChain[serviceId] ?? [:]
        keychainValues.updateValue(item, forKey: item.instanceURL)
        mockKeyChain.updateValue(keychainValues, forKey: serviceId)
    }
    
    static func retrieve(for instanceURL: String) throws -> ForceAuth? {
        let keychainValues = mockKeyChain[serviceId] ?? [:]
        return keychainValues.values.first
    }
    
    static func retrieveAll() throws -> [ForceAuth] {
        let keychainValues = mockKeyChain[serviceId] ?? [:]
        var connectedAppValues: [ForceAuth] = []
        for value in keychainValues.values {
            connectedAppValues.append(value)
        }
        return connectedAppValues
    }
    
    static func delete(for instanceURL: String) throws {
        mockKeyChain.removeValue(forKey: serviceId)
    }
    
    static func clear() {
        mockKeyChain.removeAll()
    }
}
