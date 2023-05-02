//
//  KeychainManagerProtocol.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/12/23.
//

import Foundation

protocol KeychainManagerProtocol {
    associatedtype T
    static func save(item: T) throws
    static func retrieve(for accountId: String) throws -> T?
    static func retrieveAll() throws -> [T]
    static func delete(for accountId: String) throws
}
