/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public struct ForceRequest {
    
    public struct Method {
        static let get = "GET"
        static let delete = "DELETE"
        static let post = "POST"
        static let patch = "PATCH"
        static let head = "HEAD"
        static let put = "PUT"
    }
    
    public struct MIMEType {
        static let json = "application/json;charset=UTF-8"
        static let formUrlEncoded = "application/x-www-form-urlencoded;charset=utf-8"
    }
    
    public struct Header {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    // create a URLRequest with path
    public static func create(
        path: String,
        method: String? = nil,
        queryItems: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0
    ) throws -> URLRequest {
        
        do {
            let config = try ForceConfig.config()
            // URL
            var comps = URLComponents()
            comps.scheme = "https"
            
            comps.host = URL(string: config.instanceURL)?.host ?? ""
            comps.path = path.starts(with: "/") ? path : "/\(path)"
            if let queryItems = queryItems {
                comps.queryItems = queryItems.map({ (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: value)
                })
            }
            guard let url = comps.url else {
                throw URLError(.badURL)
            }
            
            return createRequest(from: url, method: method, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        } catch {
            throw error
        }
        
    }
    
    // create a URLRequest with URL
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
        
        return newURL
    }
    
    public static func createRequest(from url: URL,
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
        let defaultHeaders: [String:String] = [
            Header.accept : MIMEType.json,
            Header.contentType : contentType
        ].reduce(into: [:]) { $0[$1.0] = $1.1 }
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:]) { (_, new) in new }
        
        return request
    }
    
    public static func setAuthorization(request: URLRequest, accessToken: String) -> URLRequest {
        
        var newRequest = request
        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
}

