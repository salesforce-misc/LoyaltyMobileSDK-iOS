//
//  Request.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

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
    
    static func create(
        auth: ForceAuth = ForceAuth(
            accessToken: "00D4x000008ZreC!AQcAQIfjC.7PiGmZ9ZypJtcZibfGXMeyV1nkviKhOtMzsKRVgq9M9oCJoHhZrzVTSGt85jTL64RX9ObsqAaCECDMphDNvB7A",
            instanceURL: URL(string: "https://internalmobileteam-dev-ed.develop.my.salesforce.com")!,
            identityURL: URL(string: "https://login.salesforce.com/id/00D4x000008ZreCEAS/0054x000005teDHAAY"),
            timestamp: .now,
            refreshToken: ""),
        method: String? = nil,
        path: String,
        queryItems: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0
    ) throws -> URLRequest {
        
        // URL
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = auth.instanceURL.host
        comps.path = path.starts(with: "/") ? path : "/\(path)"
        guard let url = comps.url else {
            throw URLError(.badURL)
        }
        
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
        
        request.setValue("Bearer \(auth.accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

