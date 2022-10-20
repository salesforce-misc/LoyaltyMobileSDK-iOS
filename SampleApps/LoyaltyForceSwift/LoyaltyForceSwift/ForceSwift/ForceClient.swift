//
//  APIManager.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/1/22.
//

import Foundation
import Combine
  
public class ForceClient {
    
    public static let shared = ForceClient()
    
    private init() {}
    
    func handleDataAndResponse(output: URLSession.DataTaskPublisher.Output) -> Data {
        handleResponse(response: output.response)
        return output.data
    }
    
    func handleResponse(response: URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print(ForceError.requestFailed(description: "<ForceError> - Invalid response").customDescription)
            return
        }
            
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print(ForceError.responseUnsuccessful(description: "<ForceError> - HTTP response status code \(httpResponse.statusCode)").customDescription)
            return
        }
    }
    
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw ForceError.authenticationNeeded
        }
    }

    /// Use Async/Await to fetch all REST requests
    public func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T {
      
        do {
            
            let output = try await URLSession.shared.data(for: request)
            try handleUnauthResponse(output: output)
            let data = handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch ForceError.authenticationNeeded {
            let newRequet = try await getNewRequest(for: request)
            let output = try await URLSession.shared.data(for: newRequet)
            try handleUnauthResponse(output: output)
            let data = handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
    
    public func fetchLocalJson<T: Decodable>(
        type: T.Type,
        file: String) throws -> T {
            
        guard let fileURL = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey : "\(file).json"])
        }
      
        return try JSONDecoder().decode(T.self, from: try Data(contentsOf: fileURL))
    }
    
    func getNewRequest(for request: URLRequest) async throws -> URLRequest {
        
        do {
            let auth = try ForceAuthManager.shared.retrieveAuth()
            if let refreshToken = auth.refreshToken {
                let newAuth = try await ForceAuthManager.shared.refresh(consumerKey: ForceConfig.defaultConsumerKey, refreshToken: refreshToken)
                return ForceRequest.updateRequest(from: request, with: newAuth)
            } else {
                let config = try ForceConfig.config()
                let newAuth = try await ForceAuthManager.shared.grantAuth(
                    url: config.authURL,
                    username: config.username,
                    password: config.password,
                    consumerKey: config.consumerKey,
                    consumerSecret: config.consumerSecret)
                return ForceRequest.updateRequest(from: request, with: newAuth)
            }
        } catch {
            throw error
        }
    }

}
