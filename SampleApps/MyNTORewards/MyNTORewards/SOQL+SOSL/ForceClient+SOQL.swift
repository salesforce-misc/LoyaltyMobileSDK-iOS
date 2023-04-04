/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import LoyaltyMobileSDK

public extension ForceClient {
    
    func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T> {
        
        do {
            let path = ForceAPI.path(for: "query")
            let queryItems = ["q": query]
            let request = try ForceRequest.create(instanceURL: AppSettings.getConnectedApp().instanceURL, path: path, queryItems: queryItems)
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
            let request = try ForceRequest.create(instanceURL: AppSettings.getConnectedApp().instanceURL, path: path)
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
