/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
  
public class ForceClient {
    public var auth: ForceAuthenticator
    public var forceNetworkManager: NetworkManagerProtocol
    
    /// Create a new instance from a given ``ForceAuthenticator``
    /// - Parameter auth: A ``ForceAuthenticator``
    public init(auth: ForceAuthenticator, forceNetworkManager: NetworkManagerProtocol = NetworkManager.shared) {
            self.auth = auth
            self.forceNetworkManager = forceNetworkManager
        }
    
    /// Use Async/Await to fetch all REST requests with authentication 
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - request: A URLRequest to be executed by URLSession
    /// - Returns: A decoded JSON response result
    public func fetch<T: Decodable>(type: T.Type, with request: URLRequest, urlSession: URLSession = .shared) async throws -> T {
      
        do {
            guard let token = auth.getAccessToken() else {
                throw CommonError.authenticationNeeded
            }
            
            let newRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            return try await forceNetworkManager.fetch(type: type, request: newRequest, urlSession: .shared)
        } catch CommonError.authenticationNeeded {
            let token = try await auth.grantAccessToken()
            let updatedRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
            return try await forceNetworkManager.fetch(type: type, request: updatedRequest, urlSession: .shared)
        } catch {
            throw error
        }
    }
    
    /// Fetch from a local JSON file
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - file: Filename of a local JSON file
    /// - Returns: A decoded JSON response result
    func fetchLocalJson<T: Decodable>(type: T.Type, file: String, bundle: Bundle = Bundle.main) throws -> T {
            
        guard let fileURL = bundle.url(forResource: file, withExtension: "json") else {
            throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "\(file).json"])
        }
      
        return try JSONDecoder().decode(T.self, from: try Data(contentsOf: fileURL))
    }
    
}
