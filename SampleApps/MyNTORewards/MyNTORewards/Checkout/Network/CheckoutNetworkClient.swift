//
//  CheckoutNetworkClient.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/05/23.
//

import Foundation
import LoyaltyMobileSDK

public class CheckoutNetworkClient {
	
	public var auth: CheckoutAuthManager
	public var checkoutNetworkManager: CheckoutNetworkManager
	
	/// Create a new instance from a given `ForceAuthenticator`
	/// - Parameters:
	///   - auth: A `ForceAuthenticator` instance
	///   - forceNetworkManager: A `NetworkManagerProtocol` instance (defaults to `NetworkManager.shared`)
	public init(auth: CheckoutAuthManager, checkoutNetworkManager: CheckoutNetworkManager = CheckoutNetworkManager.shared) {
		self.auth = auth
		self.checkoutNetworkManager = checkoutNetworkManager
	}
	
	/// Use Async/Await to fetch all REST requests with authentication
	/// - Parameters:
	///   - type: A type(i.e. model) defined to be used by JSON decoder
	///   - request: A URLRequest to be executed by URLSession
	/// - Returns: A decoded JSON response result
	public func fetch<T: Decodable>(type: T.Type, with request: URLRequest, urlSession: URLSession = .shared) async throws -> T {
		
		do {
			guard let token = await auth.getAccessToken() else {
				throw CommonError.authenticationNeeded
			}
			
			let newRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
			return try await checkoutNetworkManager.fetch(type: type, request: newRequest, urlSession: .shared)
		} catch CommonError.authenticationNeeded {
			let token = try await auth.grantAccessToken()
			let updatedRequest = ForceRequest.setAuthorization(request: request, accessToken: token)
			return try await checkoutNetworkManager.fetch(type: type, request: updatedRequest, urlSession: .shared)
		} catch {
			throw error
		}
	}
	
	public func fetchLocalJson<T: Decodable>(type: T.Type, file: String, bundle: Bundle = Bundle.publicModule) throws -> T {

		guard let fileURL = bundle.url(forResource: file, withExtension: "json") else {
			throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "\(file).json"])
		}

		return try JSONDecoder().decode(T.self, from: try Data(contentsOf: fileURL))
	}
	
	func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T> {
		
		do {
			let path = ForceAPI.path(for: "query", version: LoyaltyAPIVersion.defaultVersion)
			let queryItems = ["q": query]
			let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(), path: path, queryItems: queryItems)
			return try await fetch(type: QueryResult.self, with: request)
		} catch {
			throw error
		}
	}
}
