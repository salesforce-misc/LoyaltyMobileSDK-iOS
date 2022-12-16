//
//  ForceAuthSafe.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/11/22.
//

import Foundation

struct ForceAuthStore {
    
    static let consumerKey: String = ForceConfig.defaultConsumerKey
    
    static func save(auth: ForceAuth) throws {
        let data = try JSONEncoder().encode(auth)
        try Keychain.write(data: data, service: consumerKey, account: auth.identityURL)
    }
    
    static func retrieve(for identityURL: String) throws -> ForceAuth? {
        do {
            let data = try Keychain.read(service: consumerKey, account: identityURL)
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
            try Keychain.delete(service: consumerKey, account: identityURL)
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
