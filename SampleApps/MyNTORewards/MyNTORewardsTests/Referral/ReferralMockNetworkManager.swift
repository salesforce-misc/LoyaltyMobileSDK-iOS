//
//  ReferralMockNetworkManager.swift
//  MyNTORewardsTests
//
//  Created by Damodaram Nandi on 30/01/24.
//

import XCTest
@testable import ReferralMobileSDK

class ReferralMockNetworkManager: NetworkManagerProtocol {
    public var statusCode = 200
    
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
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
            Logger.error(CommonError.responseUnsuccessful(message: errorMessage, displayMessage: "").description)
            Logger.debug(httpResponse.description)
            throw CommonError.responseUnsuccessful(message: errorMessage, displayMessage: "")
        }
    }
    
    static let sharedMock = ReferralMockNetworkManager()
    
    func fetch<T>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T where T: Decodable {
        let data = try await responseData(type: T.Type.self)
        let mockSession = URLSession.mock(responseBody: data, statusCode: statusCode)
        let output = try await mockSession.data(for: request)
        try handleUnauthResponse(output: output)
        statusCode = 200
        
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
        return try decoder.decode(type, from: output.0)
    }
    
    func responseData<T>(type: T.Type) async throws -> Data {
        if type.self == ReferralEnrollmentOutputModel.Type.self {
            return try XCTestCase.load(resource: "ReferralEnrollmentOutput")
        } else if type.self == ReferralEventOutputModel.Type.self {
            return try XCTestCase.load(resource: "ReferralEventOutput")
        }
        
        return Data()
    }
}
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

extension XCTestCase {
    
    static func load(resource: String, withExtension: String = "json", inBundle: Bundle? = nil) throws -> Data {
        let bundle = inBundle ?? Bundle.module
        guard let url = bundle.url(forResource: resource, withExtension: withExtension) else {
            throw URLError(.fileDoesNotExist, userInfo: [NSURLErrorFailingURLErrorKey: "\(resource).\(withExtension)"])
        }
        return try Data(contentsOf: url)
    }
}

final class MockURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            return
        }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Do nothing
    }
}
