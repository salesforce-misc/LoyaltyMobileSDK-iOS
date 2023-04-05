/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
  
public class ForceClient {
    public var auth: ForceAuthenticator
    
    
    /// Create a new instance from a given ``ForceAuthenticator``
    /// - Parameter auth: A ``ForceAuthenticator``
    public init(auth: ForceAuthenticator) {
        self.auth = auth
    }
    
    /// Use Async/Await to fetch all REST requests with authentication 
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - request: A URLRequest to be executed by URLSession
    /// - Returns: A decoded JSON response result
    public func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
      
        do {
            var newRequest: URLRequest
            if let token = auth.accessToken {
                newRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            } else {
                let accessToken = try await auth.grantAccessToken()
                newRequest = ForceRequest.setAuthorization(request: request, accessToken: accessToken)
            }
            return try await NetworkManager.shared.fetch(type: type, request: newRequest)
        } catch ForceError.authenticationNeeded {
            let token = try await auth.grantAccessToken()
            let updatedRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            return try await NetworkManager.shared.fetch(type: type, request: updatedRequest)
        } catch {
            throw error
        }
    }
    
    /// Fetch from a local JSON file
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - file: Filename of a local JSON file
    /// - Returns: A decoded JSON response result
    func fetchLocalJson<T: Decodable>(type: T.Type, file: String) throws -> T {
            
        guard let fileURL = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey : "\(file).json"])
        }
      
        return try JSONDecoder().decode(T.self, from: try Data(contentsOf: fileURL))
    }
    
}
