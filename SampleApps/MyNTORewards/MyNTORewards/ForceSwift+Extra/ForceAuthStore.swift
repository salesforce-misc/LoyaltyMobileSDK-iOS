/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import LoyaltyMobileSDK

struct ForceAuthStore {
    
    static let serviceId: String = ForceConfig.defaultServiceIdentifier
    
    static func save(auth: ForceAuth) throws {
        let data = try JSONEncoder().encode(auth)
        try Keychain.write(data: data, service: serviceId, account: auth.identityURL)
    }
    
    static func retrieve(for identityURL: String) throws -> ForceAuth? {
        do {
            let data = try Keychain.read(service: serviceId, account: identityURL)
            return try JSONDecoder().decode(ForceAuth.self, from: data)
        }
        catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return nil
            }
            else {
                throw error
            }
        }
    }
    
    static func delete(for identityURL: String) throws -> () {
        do {
            try Keychain.delete(service: serviceId, account: identityURL)
        }
        catch {
            if case Keychain.KeychainError.itemNotFound = error {
                return
            }
            else {
                throw error
            }
        }
    }
}
