/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

extension URLSession {
    
    static func mock(withLoadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?) -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.loadingHandler = withLoadingHandler
        return URLSession.init(configuration: configuration)
    }
    
    static func mock(responseBody: Data, statusCode: Int) -> URLSession {
        let loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))? = { request in
            guard let url = request.url,
                  let metadata = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
                fatalError("request.url or HTTPURLResponse is nil")
            }
            return (metadata, responseBody, nil)
        }
        return mock(withLoadingHandler: loadingHandler)
    }
    
    static func mock(error: Error, statusCode: Int) -> URLSession {
        let loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))? = { request in
            guard let url = request.url,
                  let metadata = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
                fatalError("request.url or HTTPURLResponse is nil")
            }
            return (metadata, nil, error)
        }
        return mock(withLoadingHandler: loadingHandler)
    }
}
