//
//  Connection+API+RestService.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftlySalesforce

struct RestService<T: Decodable>: DataService {
        
    typealias Output = T
    
    let version: String
    let path: String
    
    var method: String? = nil
    var queryItems: [String: String]? = nil
    var headers: [String:String]? = nil
    var body: Data? = nil
    var timeoutInterval: TimeInterval = URLRequest.defaultTimeoutInterval
    
    func createRequest(with credential: Credential) throws -> URLRequest {
        return try URLRequest(
            credential: credential,
            method: method,
            path: "/services/data/v\(version)\(path.starts(with: "/") ? path : "/\(path)")",
            queryItems: queryItems,
            headers: headers,
            body: body,
            timeoutInterval: timeoutInterval
        )
    }
}

public extension Connection {
    
    static let defaultApiVersion = AppConstants.Config.apiVersion
    /// Calls a REST service.
    ///
    ///
    /// - Parameters:
    ///     - method: Optional, HTTP method to use; if `nil` then GET will be used in the request.
    ///     - version: API version to run for REST service
    ///     - path: Path to the REST service, as defined in the `urlMapping` of the `@RestResource` annotation on the target class.
    ///     - queryItems: Optional query items to include in the request.
    ///     - headers: Optional `HTTP` headers to include in the request.
    ///     - body: Request body for a `POST` , `PATCH` or `PUT`  request.
    ///     - timeoutInterval: request timeout interval, in seconds.
    ///
    /// - Returns: The `Decodable` return value from the REST response.
    ///
    func rest<T: Decodable>(
        type: T.Type,
        method: String? = nil,
        version: String = defaultApiVersion,
        path: String,
        queryItems: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        timeoutInterval: TimeInterval = URLRequest.defaultTimeoutInterval
    ) async throws -> T {
        
        let service = RestService<T>(version: version, path: path, method: method, queryItems: queryItems, headers: headers, body: body, timeoutInterval: timeoutInterval)
        return try await request(service: service)
    }
}
