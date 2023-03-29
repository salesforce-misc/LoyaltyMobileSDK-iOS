/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public class ForceNetworkManager {
    
    public static let shared = ForceNetworkManager()
    
    private init() {}
    
    internal func handleDataAndResponse(output: URLSession.DataTaskPublisher.Output) -> Data {
        handleResponse(response: output.response)
        return output.data
    }
    
    internal func handleResponse(response: URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print(ForceError.requestFailed(description: "<ForceError> - Invalid response").customDescription)
            return
        }
            
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print(ForceError.responseUnsuccessful(description: "<ForceError> - HTTP response status code \(httpResponse.statusCode)").customDescription)
            print(httpResponse.description)
            return
        }
    }
    
    internal func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw ForceError.authenticationNeeded
        }
    }

    /// Use Async/Await to fetch all REST requests
    public func fetch<T: Decodable>(type: T.Type, request: URLRequest) async throws -> T {
      
        do {
            let output = try await URLSession.shared.data(for: request)
            try handleUnauthResponse(output: output)
            let data = handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
}
