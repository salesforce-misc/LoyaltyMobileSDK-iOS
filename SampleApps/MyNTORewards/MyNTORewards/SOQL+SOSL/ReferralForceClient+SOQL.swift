//
//  ReferralForceClient+SOQL.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/10/24.
//

import Foundation
import ReferralMobileSDK

extension ForceClient {
    
    func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T> {
        
        do {
            let path = ForceAPI.path(for: "query", version: ReferralAPIVersion.defaultVersion)
            let queryItems = ["q": query]
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path, queryItems: queryItems)
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
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path)
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
