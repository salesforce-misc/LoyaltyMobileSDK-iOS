//
//  MockKeychainManager.swift
//
//
//  Created by Anandhakrishnan Kanagaraj on 17/05/23.
//

import XCTest
@testable import MyNTORewards

final class MockConnectedAppManager: KeychainManagerProtocol {
    
    typealias T = ForceConnectedApp
    static var mockKeyChain: [String: [String: ForceConnectedApp]] = [:]
    static let serviceId = "LoyaltyMobileSDK.ConnectedApp.unittest"
    
    static func save(item: ForceConnectedApp) throws {
        var keychainValues = mockKeyChain[serviceId] ?? [:]
        keychainValues.updateValue(item, forKey: item.instanceURL)
    }
    
    static func retrieve(for instanceURL: String) throws -> ForceConnectedApp? {
        let keychainValues = mockKeyChain[serviceId] ?? [:]
        return keychainValues[instanceURL]
    }
    
    static func retrieveAll() throws -> [ForceConnectedApp] {
        let keychainValues = mockKeyChain[serviceId] ?? [:]
        var connectedAppValues: [ForceConnectedApp] = []
        for value in keychainValues.values {
            connectedAppValues.append(value)
        }
        return connectedAppValues
    }
    
    static func delete(for instanceURL: String) throws {
        var keychainValues = mockKeyChain[serviceId] ?? [:]
        keychainValues.removeValue(forKey: instanceURL)
    }
    
    static func clear() {
        mockKeyChain.removeAll()
    }
}
