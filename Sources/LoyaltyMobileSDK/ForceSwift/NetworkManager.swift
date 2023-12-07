/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A protocol that defines the requirements for a network manager.
public protocol NetworkManagerProtocol {
    /// Fetch data from the network and decode it to the specified type.
    ///
    /// - Parameters:
    ///   - type: The expected data type to decode the response into.
    ///   - request: The URLRequest to be executed by URLSession.
    ///   - urlSession: An instance of URLSession to execute the request. Defaults to URLSession.shared.
    ///
    /// - Returns: A decoded JSON response result.
    func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T
}

/// A class that handles network requests and data processing.
public class NetworkManager: NetworkManagerProtocol {
    
    /// A shared instance of NetworkManager for convenience.
    public static let shared = NetworkManager()
    
    /// Private initializer to prevent multiple instances.
    private init() {}
    
    /// Handle data and response from a URLSession request.
    ///
    /// - Parameter output: A tuple containing the Data and URLResponse from the request.
    ///
    /// - Returns: Validated data from the request.
    /// - Throws: A CommonError if there's an issue with the response or data.
    internal func handleDataAndResponse(output: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = output.response as? HTTPURLResponse else {
            let error = CommonError.requestFailed(message: "Invalid response")
            Logger.error(error.description)
            throw error
        }

        Logger.debug("HTTP response code is: \(httpResponse.statusCode)")

        if !(200..<300).contains(httpResponse.statusCode) {
            var errorMessage = "HTTP response status code \(httpResponse.statusCode)"
            // Logger.debug(httpResponse.description)
			var displayMessage = ""

            // Attempt to decode JSON and append to errorMessage
            if let json = try? JSONSerialization.jsonObject(with: output.data, options: []) as? [String: Any] {
                // Logger.debug("Error JSON response: \(json)")
                errorMessage += ". Error JSON: \(json)"
				displayMessage = (json["message"] as? String) ?? errorMessage
            } else if let jsonString = String(data: output.data, encoding: .utf8) {
                // Logger.debug("Error response: \(jsonString)")
                errorMessage += ". Error response: \(jsonString)"
				displayMessage = jsonString
            } else {
                let rawDataDescription = "Failed to convert error data to a string. Raw data: \(output.data)"
                // Logger.debug(rawDataDescription)
                errorMessage += ". \(rawDataDescription)"
            }

            // Log and throw the error
            Logger.error(CommonError.responseUnsuccessful(message: errorMessage, displayMessage: displayMessage).description)

            // Throw appropriate error based on status code
            switch httpResponse.statusCode {
            case 401:
                throw CommonError.authenticationNeeded
            case 403:
                throw CommonError.functionalityNotEnabled
            case 500:
                throw CommonError.unknownException(displayMessage: displayMessage)
            default:
				throw CommonError.responseUnsuccessful(message: errorMessage, displayMessage: displayMessage)
            }
        }

        return output.data
    }

    /// Use Async/Await to fetch all REST requests.
    ///
    /// - Parameters:
    ///   - type: A type (i.e., model) defined to be used by JSON decoder.
    ///   - request: A URLRequest to be executed by URLSession.
    ///   - urlSession: An instance of URLSession to execute the request. Defaults to URLSession.shared.
    ///
    /// - Returns: A decoded JSON response result.
    /// - Throws: An error if the request or decoding fails.
    public func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession = URLSession.shared) async throws -> T {
        
        let dateFormatters = DateFormatter.forceFormatters()
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
                        
            for dateFormatter in dateFormatters {
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "NetworkManager cannot decode date string \(dateString)")
        }
      
        do {
            let output = try await urlSession.data(for: request)
            let data = try handleDataAndResponse(output: output)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                 Logger.debug("JSON response: \(json)")
            }
            return try decoder.decode(type, from: data)
        } catch {
            Logger.error("NetworkManager fetch/decode error: \(error)")
            throw error
        }
    }
}
