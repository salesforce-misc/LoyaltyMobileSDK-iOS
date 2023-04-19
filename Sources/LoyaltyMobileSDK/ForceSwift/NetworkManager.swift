/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import UIKit

public protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    
    private init() {}
    
    internal func handleDataAndResponse(output: URLSession.DataTaskPublisher.Output) -> Data {
        handleResponse(response: output.response)
        return output.data
    }
    
    internal func handleResponse(response: URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.error(CommonError.requestFailed(message: "Invalid response").description)
            return
        }
            
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            Logger.error(CommonError.responseUnsuccessful(message: "HTTP response status code \(httpResponse.statusCode)").description)
            Logger.debug(httpResponse.description)
            return
        }
    }
    
    public func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw CommonError.authenticationNeeded
        }
    }

    /// Use Async/Await to fetch all REST requests
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - request: A URLRequest to be executed by URLSession
    /// - Returns: A decoded JSON response result
    public func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession = URLSession.shared) async throws -> T {
      
        do {
            let output = try await urlSession.data(for: request)
            try handleUnauthResponse(output: output)
            let data = handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
}
