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
    
    func handleDataAndResponse(output: (data: Data, response: URLResponse)) -> Data {
        handleResponse(response: output.response)
        return output.data
    }
    
    func handleResponse(response: URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print(ForceError.requestFailed(description: "Invalid response").customDescription)
            return
        }
            
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print(ForceError.responseUnsuccessful(description: "Unsuccessful, status code \(httpResponse.statusCode)").customDescription)
            return
        }

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
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
    
            guard let data = data, error == nil, let response = response else {
                return
            }
            self.handleResponse(response: response)
            completion(data)
            
        }.resume()

    }
    
    // OPtion 2: Combine
    public func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) -> AnyPublisher<T, Error> {
            
        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap(handleDataAndResponse)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }

    // Option 3: Async/Await
    public func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T {
      
        do {
            let output = try await URLSession.shared.data(for: request)
            let data = handleDataAndResponse(output: output)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
    
}
