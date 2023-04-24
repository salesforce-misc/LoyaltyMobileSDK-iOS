/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import LoyaltyMobileSDK

extension ForceClient {
    
    struct SearchResult: Decodable {
        let searchRecords: [Record]
    }
    
    func SOSL(for query: String) async throws -> [Record] {
        
        do {
            let path = ForceAPI.path(for: "search", version: LoyaltyAPIVersion.defaultVersion)
            let queryItems = ["q": query]
            let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(), path: path, queryItems: queryItems)
            let result = try await fetch(type: SearchResult.self, with: request)
            return result.searchRecords
        } catch {
            throw error
        }
    }

}
