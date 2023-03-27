/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
  
public class ForceClient {
    public var auth: ForceAuthenticator
    
    public init(auth: ForceAuthenticator) {
        self.auth = auth
    }
    
    /// Use Async/Await to fetch all REST requests
    public func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
      
        do {
            var newRequest: URLRequest
            if let token = auth.accessToken {
                newRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            } else {
                let accessToken = try await auth.grantAccessToken()
                newRequest = ForceRequest.setAuthorization(request: request, accessToken: accessToken)
            }
            return try await ForceNetworkManager.shared.fetch(type: type, request: newRequest)
        } catch ForceError.authenticationNeeded {
            let token = try await auth.grantAccessToken()
            let updatedRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            return try await ForceNetworkManager.shared.fetch(type: type, request: updatedRequest)
        } catch {
            throw error
        }
    }
    
    public func fetchLocalJson<T: Decodable>(
        type: T.Type,
        file: String) throws -> T {
            
        guard let fileURL = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey : "\(file).json"])
        }
      
        return try JSONDecoder().decode(T.self, from: try Data(contentsOf: fileURL))
    }
    
}
