/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import UIKit

public protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    
    private init() {}
    
    internal func handleDataAndResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let httpResponse = output.response as? HTTPURLResponse else {
            Logger.error(CommonError.requestFailed(message: "Invalid response").description)
            throw CommonError.requestFailed(message: "Invalid response")
        }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            Logger.error(CommonError.authenticationNeeded.description)
            throw CommonError.authenticationNeeded
        case 403:
            Logger.error(CommonError.functionalityNotEnabled.description)
            throw CommonError.functionalityNotEnabled
        default:
            let errorMessage = "HTTP response status code \(httpResponse.statusCode)"
            Logger.error(CommonError.responseUnsuccessful(message: errorMessage).description)
            Logger.debug(httpResponse.description)
            throw CommonError.responseUnsuccessful(message: errorMessage)
        }

        return output.data
    }

    /// Use Async/Await to fetch all REST requests
    /// - Parameters:
    ///   - type: A type(i.e. model) defined to be used by JSON decoder
    ///   - request: A URLRequest to be executed by URLSession
    /// - Returns: A decoded JSON response result
    public func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession = URLSession.shared) async throws -> T {
      
        do {
            let output = try await urlSession.data(for: request)
            let data = try handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
}
