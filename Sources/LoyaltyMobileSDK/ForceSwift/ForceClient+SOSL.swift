//
//  ForceClient+SOSL.swift
//  LoyaltyMobileSDK
//
//  Created by Leon Qi on 9/22/22.
//

import Foundation

public extension ForceClient {
    
    struct SearchResult: Decodable {
        let searchRecords: [Record]
    }
    
    func SOSL(for query: String) async throws -> [Record] {
        
        do {
            let path = ForceConfig.path(for: "search")
            let queryItems = ["q": query]
            let request = try ForceRequest.create(path: path, queryItems: queryItems)
            let result = try await fetch(type: SearchResult.self, with: request)
            return result.searchRecords
        } catch {
            throw error
        }
    }

}
