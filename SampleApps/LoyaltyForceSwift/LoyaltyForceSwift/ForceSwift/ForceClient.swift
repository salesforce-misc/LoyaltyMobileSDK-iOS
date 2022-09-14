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
            print(ForceError.requestFailed(description: "ForceError=> Invalid response").customDescription)
            return
        }
            
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print(ForceError.responseUnsuccessful(description: "ForceError=> Unsuccessful, HTTP response status code \(httpResponse.statusCode)").customDescription)
            return
        }

    }
    
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw ForceError.authenticationNeeded
        }
    }
    
    func handleUnauthResponseReturnOutput(output: URLSession.DataTaskPublisher.Output) throws -> URLSession.DataTaskPublisher.Output {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw ForceError.authenticationNeeded
        }
        
        return output
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // Option 1: @escaping closure
    public func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest,
        completion: @escaping (_ data: Data?) -> Void) {
            
            Task {
                do {
                    // Get a updated request with a new token
                    let newRequest = try await getNewRequest(for: request)
                    
                    URLSession.shared.dataTask(with: newRequest) { (data, response, error) in
                
                        guard let data = data, error == nil, let response = response else {
                            return
                        }
                        self.handleResponse(response: response)
                        completion(data)
                        
                    }.resume()
                } catch {
                    print("Error fetching request (@escaping closure): \(error.localizedDescription)")
                }
            }
    }
    
    // OPtion 2: Combine
//    public func fetch<T: Decodable>(
//        type: T.Type,
//        with request: URLRequest) -> AnyPublisher<T, Error> {
//            
//            Task {
//                // To test request without a valid accessToken
//                if let token = ForceAuthManager.shared.auth?.accessToken {
//                    try await ForceAuthManager.shared.revoke(token: token)
//                }
//
//                do {
//                    // Get a updated request with a new token
//                    let newRequest = try await getNewRequest(for: request)
//
//                    return URLSession.shared.dataTaskPublisher(for: newRequest)
//                            .tryMap(handleDataAndResponse)
//                            .decode(type: T.self, decoder: JSONDecoder())
//                            .eraseToAnyPublisher()
//
//                } catch {
//                    print("Error fetching request (Combine): \(error.localizedDescription)")
//                    return Empty(completeImmediately: false).eraseToAnyPublisher()
//                }
//            }
//    
//    }

    // Option 3: Async/Await
    public func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T {
      
        do {
            
//            // To test request without a valid accessToken
//            if let token = ForceAuthManager.shared.auth?.accessToken {
//                try await ForceAuthManager.shared.revoke(token: token)
//            }
            
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
    
    func getNewRequest(for request: URLRequest) async throws -> URLRequest {
        
        do {
            guard let id = ForceAuthManager.shared.userIdentifier else {
                throw ForceError.userIdentityUnknown
            }
            guard let auth = try ForceAuthStore.retrieve(for: id) else {
                throw ForceError.authNotFoundInKeychain
            }
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
