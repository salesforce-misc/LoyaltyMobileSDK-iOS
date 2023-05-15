/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A struct to help create and configure URLRequest instances.
public struct ForceRequest {
    
    /// Constants for HTTP methods.
    public struct Method {
        static let get = "GET"
        static let delete = "DELETE"
        static let post = "POST"
        static let patch = "PATCH"
        static let head = "HEAD"
        static let put = "PUT"
    }
    
    /// Constants for MIME types.
    public struct MIMEType {
        static let json = "application/json;charset=UTF-8"
        static let formUrlEncoded = "application/x-www-form-urlencoded;charset=utf-8"
    }
    
    /// Constants for HTTP headers.
    public struct Header {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    /// create a URLRequest with path
    /// - Parameters:
    ///   - instanceURL: The instanceURL of the org
    ///   - path: The path of the request
    ///   - method: The HTTP Method, for example ``GET``, ``POST`` and etc
    ///   - queryItems: The request queryItems
    ///   - headers: The request headers
    ///   - body: The request body
    ///   - cachePolicy: The request ``CachePolicy``
    ///   - timeoutInterval: The request ``TimeInterval``
    /// - Returns: A ``URLRequest``
    public static func create(
        instanceURL: String,
        path: String,
        method: String? = nil,
        queryItems: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0
    ) throws -> URLRequest {
        
        do {
            // URL
            var comps = URLComponents()
            comps.scheme = "https"
            guard let url = URL(string: instanceURL) else {
                throw URLError(.badURL)
            }
            comps.host = url.host
            comps.path = path.starts(with: "/") ? path : "/\(path)"
            if let queryItems = queryItems {
                comps.queryItems = queryItems.map({ (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: value)
                })
            }
            guard let requestURL = comps.url else {
                throw URLError(.badURL)
            }
            
            return createRequest(from: requestURL, method: method, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        } catch {
            throw error
        }
    }
    
    /// create a URLRequest with URL
    /// - Parameters:
    ///   - url: The request ``URL``
    ///   - method: The HTTP Method, for example ``GET``, ``POST`` and etc
    ///   - queryItems: The request queryItems
    ///   - headers: The request headers
    ///   - body: The request body
    ///   - cachePolicy: The request ``CachePolicy``
    ///   - timeoutInterval: The request ``TimeInterval``
    /// - Returns: A ``URLRequest``
    public static func create(
        url: URL,
        method: String? = nil,
        queryItems: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0
    ) throws -> URLRequest {
        
        var requestURL = url
        if let queryItems = queryItems {
            requestURL = try transform(from: url, add: queryItems)
        }
        
        return createRequest(from: requestURL, method: method, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /// create a URLRequest with URL
    /// - Parameters:
    ///   - url: The request ``URL``
    ///   - method: The HTTP Method, for example ``GET``, ``POST`` and etc
    ///   - headers: The request headers
    ///   - body: The request body
    ///   - cachePolicy: The request ``CachePolicy``
    ///   - timeoutInterval: The request ``TimeInterval``
    /// - Returns: A ``URLRequest``
    private static func createRequest(
        from url: URL,
        method: String? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0 ) -> URLRequest {
        
        // URLRequest
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method
        request.httpBody = body
        
        // Headers
        let contentType: String = {
            switch method?.uppercased() {
            case nil, Method.get.uppercased(), Method.delete.uppercased():
                return MIMEType.formUrlEncoded
            default:
                return MIMEType.json
            }
        }()
        let defaultHeaders: [String: String] = [
            Header.accept: MIMEType.json,
            Header.contentType: contentType
        ].reduce(into: [:]) { $0[$1.0] = $1.1 }
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:]) { (_, new) in new }
        
        return request
    }
    
    /// Transform a URL with queryItems added
    /// - Parameters:
    ///   - url: The URL to be transformed
    ///   - queryItems: QueryItems to be added
    /// - Returns: A new URL with queryItems added
    public static func transform(from url: URL, add queryItems: [String: String]) throws -> URL {

        var comps = URLComponents()
        comps.scheme = url.scheme
        comps.host = url.host
        comps.path = url.path
        comps.queryItems = queryItems.map({ (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        })
        guard let newURL = comps.url else {
            throw URLError(.badURL)
        }
        
        Logger.debug("ForceRequest: The new URL with queryItems has transformed to \(newURL.absoluteString)")
        
        return newURL
    }
    
    /// Attach an accessToken to the request
    /// - Parameters:
    ///   - request: A request to be updated
    ///   - accessToken: An accessToken for an API service
    /// - Returns: A new ``URLRequest`` with authorization added
    public static func setAuthorization(request: URLRequest, accessToken: String) -> URLRequest {
        
        var newRequest = request
        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
}
