//
//  ForceConnectedAppKeychainManager.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/12/23.
//

import Foundation
import LoyaltyMobileSDK

struct ForceConnectedAppKeychainManager: KeychainManagerProtocol {
    
    static let serviceId: String = AppSettings.Defaults.keychainConnectedAppServiceId
    
    static func save(item app: ForceConnectedApp) throws {
        let data = try JSONEncoder().encode(app)
        try Keychain.write(data: data, service: serviceId, account: app.instanceURL)
    }
    
    static func retrieve(for instanceURL: String) throws -> ForceConnectedApp? {
        do {
            let data = try Keychain.read(service: serviceId, account: instanceURL)
            return try JSONDecoder().decode(ForceConnectedApp.self, from: data)
        } catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return nil
            } else {
                throw error
            }
        }
    }
    
    static func retrieveAll() throws -> [ForceConnectedApp] {
        do {
            let dataArray = try Keychain.read(service: serviceId)
            let decoder = JSONDecoder()
            
            var appArray: [ForceConnectedApp] = []
            
            for data in dataArray {
                do {
                    let app = try decoder.decode(ForceConnectedApp.self, from: data)
                    appArray.append(app)
                } catch {
                    Logger.error("Error decoding ForceConnectedApp object: \(error)")
                }
            }
            return appArray
        } catch {
            throw error
        }
    }
    
    static func delete(for instanceURL: String) throws {
        do {
            try Keychain.delete(service: serviceId, account: instanceURL)
        } catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return
            } else {
                throw error
            }
        }
    }
}
