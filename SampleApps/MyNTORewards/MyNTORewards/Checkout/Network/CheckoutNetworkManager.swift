//
//  CheckoutNetworkManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation
import LoyaltyMobileSDK

/// A class that handles network requests and data processing.
public class CheckoutNetworkManager: NetworkManagerProtocol {
	
	/// A shared instance of NetworkManager for convenience.
	public static let shared = CheckoutNetworkManager()
	
	/// Private initializer to prevent multiple instances.
	private init() {}
	
	/// Handle data and response from a URLSession request.
	///
	/// - Parameter output: A tuple containing the Data and URLResponse from the request.
	///
	/// - Returns: Validated data from the request.
	/// - Throws: A CommonError if there's an issue with the response or data.
	internal func handleDataAndResponse(output: (data: Data, response: URLResponse)) throws -> Data {
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
			Logger.error(CommonError.responseUnsuccessful(message: errorMessage).description)
			Logger.debug(httpResponse.description)
			throw CommonError.responseUnsuccessful(message: errorMessage)
		}
		
		return output.data
	}
	
	/// Use Async/Await to fetch all REST requests.
	///
	/// - Parameters:
	///   - type: A type (i.e., model) defined to be used by JSON decoder.
	///   - request: A URLRequest to be executed by URLSession.
	///   - urlSession: An instance of URLSession to execute the request. Defaults to URLSession.shared.
	///
	/// - Returns: A decoded JSON response result.
	/// - Throws: An error if the request or decoding fails.
	public func fetch<T: Decodable>(type: T.Type, request: URLRequest, urlSession: URLSession = URLSession.shared) async throws -> T {
		
		do {
			let output = try await urlSession.data(for: request)
			let data = try handleDataAndResponse(output: output)
			return try JSONDecoder().decode(type, from: data)
		} catch {
			throw error
		}
	}
}
