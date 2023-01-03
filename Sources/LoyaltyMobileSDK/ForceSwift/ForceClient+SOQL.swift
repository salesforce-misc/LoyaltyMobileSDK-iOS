//
//  ForceClient+SOQL.swift
//  LoyaltyMobileSDK
//
//  Created by Leon Qi on 9/22/22.
//

import Foundation

public extension ForceClient {
    
    func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T> {
        
        do {
            let path = ForceConfig.path(for: "query")
            let queryItems = ["q": query]
            let request = try ForceRequest.create(path: path, queryItems: queryItems)
            return try await fetch(type: QueryResult.self, with: request)
        } catch {
            throw error
        }
    }
    
    func SOQL(for query: String) async throws -> QueryResult<Record> {
        
        do {
            return try await SOQL(type: Record.self, for: query)
        } catch {
            throw error
        }
    }
    
    func SOQLNextRecords<T: Decodable>(type: T.Type, path: String) async throws -> QueryResult<T> {
        do {
            let request = try ForceRequest.create(path: path)
            return try await fetch(type: QueryResult.self, with: request)
        } catch {
            throw error
        }
    }
    
    func SOQLNextRecords(path: String) async throws -> QueryResult<Record> {
        do {
            return try await SOQLNextRecords(type: Record.self, path: path)
        } catch {
            throw error
        }
    }
}
