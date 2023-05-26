/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import LoyaltyMobileSDK

public struct ForceAuthKeychainManager: KeychainManagerProtocol {
    
    public typealias  T = ForceAuth
    static let serviceId: String = AppSettings.Defaults.keychainAuthServiceId
    
    public static func save(item auth: ForceAuth) throws {
        let data = try JSONEncoder().encode(auth)
        try Keychain.write(data: data, service: serviceId, account: auth.identityURL)
    }
    
    public static func retrieve(for identityURL: String) throws -> ForceAuth? {
        do {
            let data = try Keychain.read(service: serviceId, account: identityURL)
            return try JSONDecoder().decode(ForceAuth.self, from: data)
        } catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return nil
            } else {
                throw error
            }
        }
    }
    
    public static func retrieveAll() throws -> [ForceAuth] {
        do {
            let dataArray = try Keychain.read(service: serviceId)
            let decoder = JSONDecoder()
            
            var forceAuthArray: [ForceAuth] = []
            
            for data in dataArray {
                do {
                    let forceAuth = try decoder.decode(ForceAuth.self, from: data)
                    forceAuthArray.append(forceAuth)
                } catch {
                    Logger.error("Error decoding ForceAuth object: \(error)")
                }
            }
            return forceAuthArray
        } catch {
            throw error
        }
    }
    
    public static func delete(for identityURL: String) throws {
        do {
            try Keychain.delete(service: serviceId, account: identityURL)
        } catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return
            } else {
                throw error
            }
        }
    }
}
