//
//  ForceAuthSafe.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/11/22.
//

import Foundation

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
