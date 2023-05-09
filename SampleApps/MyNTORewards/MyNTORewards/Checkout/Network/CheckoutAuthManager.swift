//
//  CheckoutAuthManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation
import LoyaltyMobileSDK

struct CheckoutAuthResponse: Decodable {
	let accessToken: String
	let instanceURL: String
	let id: String
	let tokenType: String
	let issuedAt: String
	let signature: String
	
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case instanceURL = "instance_url"
		case id
		case tokenType = "token_type"
		case issuedAt = "issued_at"
		case signature
	}
}

public class CheckoutAuthManager {
	public var auth: CheckoutAuth?
	private let defaults: UserDefaults
	public static let shared = CheckoutAuthManager()
	private init(defaults: UserDefaults = .shared) {
		self.defaults = defaults
	}
	
	public func getAccessToken() async -> String? {
		let baseURL = CheckoutConfig.Defaults.baseURL
		let tokenPath = CheckoutConfig.Defaults.tokenPath
		let url = baseURL+tokenPath
		do {
			return try await requestAuthToken(url: url,
											  username: "admin_aa_22852@loyaltysampleapp.com",
											  password: "test@321",
											  clientId: "3MVG9kBt168mda_.AhACC.RZAxIT77sS1y2_ltn1YMi4tG98ZA1nMiP2w6m51xen0Of_0TWZ8RTvPy05bK5p9",
											  clientSecret: "F89D25E00C8295DBDD0F8AD08750E69633B6E46B6515AA8BED7D30CDEEA2BD5E")
		} catch {
			return nil
		}
	}
	
	public func requestAuthToken(
		url: String,
		username: String,
		password: String,
		clientId: String,
		clientSecret: String
	) async throws -> String? {
		let queryItems = [
			"username": username,
			"password": password,
			"grant_type": "password",
			"client_id": clientId,
			"client_secret": clientSecret
		]
		do {
			guard let url = URL(string: url) else { return nil }
			
			let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
			let output = try await CheckoutNetworkManager.shared.fetch(type: CheckoutAuthResponse.self, request: request)
			return output.accessToken
		} catch {
			throw error
		}
	}
	
	public func grantAccessToken() async throws -> String {
		let config = CheckoutConfig.Defaults.self
		let url = config.baseURL + config.tokenPath

		if let refreshToken = self.auth?.refreshToken {
			do {
				let newAuth = try await refresh(url: url,
												consumerKey: config.consumerKey,
												refreshToken: refreshToken)
				self.auth = newAuth
				return newAuth.accessToken
			} catch {
				throw error
			}
		} else {
			do {
				let savedAuth = try retrieveAuth()
				self.auth = savedAuth
				guard let savedRefreshToken = savedAuth.refreshToken else {
					throw CommonError.authenticationFailed
				}
				let newAuth = try await refresh(url: url,
												consumerKey: config.consumerKey,
												refreshToken: savedRefreshToken)
				self.auth = newAuth
				return newAuth.accessToken

			} catch {
				throw error
			}
		}
	}

	public func authenticate(
		communityURL: String = CheckoutConfig.Defaults.communityURL,
		consumerKey: String = CheckoutConfig.Defaults.consumerKey,
		callbackURL: String = CheckoutConfig.Defaults.callbackURL,
		username: String = CheckoutConfig.Defaults.username,
		password: String = CheckoutConfig.Defaults.password
	) async throws -> CheckoutAuth {

		guard let url = URL(string: communityURL),
			  let callbackURL = URL(string: callbackURL) else {
			throw URLError(.badURL)
		}

		var authURL: URL
		var tokenURL: URL

		if #available(iOS 16, *) {
			authURL = url.appending(path: "/services/oauth2/authorize")
			tokenURL = url.appending(path: "/services/oauth2/token")
		} else {
			authURL = url.appendingPathComponent("/services/oauth2/authorize")
			tokenURL = url.appendingPathComponent("/services/oauth2/token")
		}

		do {
			guard let code = try await requestAuthorizationCode(url: authURL,
																consumerKey: consumerKey,
																callbackURL: callbackURL,
																username: username,
																password: password) else {
				throw CommonError.codeCredentials
			}

			return try await requestAccessToken(url: tokenURL,
												authCode: code,
												consumerKey: consumerKey,
												callbackURL: callbackURL)

		} catch {
			throw error
		}
	}

	/// Part 1 - Makes a Headless Request for an Authorization Code
	private func requestAuthorizationCode(
		url: URL,
		consumerKey: String,
		callbackURL: URL,
		username: String,
		password: String
	) async throws -> String? {

		let queryItems = [
			"scope": "api refresh_token", // These scopes need to be selected from Connected App Settings
			"response_type": "code_credentials",
			"client_id": consumerKey,
			"redirect_uri": callbackURL.absoluteString,
			"username": username,
			"password": password
		]

		let headers = [
			"Auth-Request-Type": "Named-User"
		]

		do {
			let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems, headers: headers)

			let output = try await URLSession.shared.data(for: request)

			guard let response = output.1 as? HTTPURLResponse,
				  let url = response.url,
				  response.statusCode == 401 else {
				throw CommonError.codeCredentials
			}

			guard let authCode = getAuthorizationCode(fromUrl: url) else {
				throw CommonError.codeCredentials
			}
			Logger.debug(authCode)
			return authCode

		} catch {
			throw error
		}

	}

	private func getAuthorizationCode(fromUrl: URL) -> String? {

		guard let components = URLComponents(url: fromUrl, resolvingAgainstBaseURL: false) else {
			return nil
		}

		guard let queryItems = components.queryItems else {
			return nil
		}

		guard let code = queryItems["code"] else {
			return nil
		}

		return code.replacingOccurrences(of: "%3D", with: "=")

	}

	/// Part 2 - Requests an Access Token (and Refresh Token)
	private func requestAccessToken(
		url: URL,
		authCode: String,
		consumerKey: String,
		callbackURL: URL
	) async throws -> CheckoutAuth {

		let queryItems = [
			"code": authCode,
			"grant_type": "authorization_code",
			"client_id": consumerKey,
			"redirect_uri": callbackURL.absoluteString
		]

		do {
			let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
			let auth = try await CheckoutNetworkManager.shared.fetch(type: CheckoutAuth.self, request: request)

			Logger.debug("\(auth)")
			try saveAuth(for: auth)
			return auth

		} catch {
			throw error
		}

	}

	public func getAuth() -> CheckoutAuth? {
		if let auth = self.auth {
			return auth
		} else {
			do {
				let savedAuth = try retrieveAuth()
				self.auth = savedAuth
				return savedAuth
			} catch {
				Logger.debug("No auth found. Please login.")
			}
		}
		return nil
	}

	/// Unique identifier for current Salesforce user.
	public var userIdentifier: ForceUserIdentifier? {
		get {
			return defaults.userIdentifier
		}
		set {
			self.defaults.userIdentifier = newValue
		}
	}

	public func refresh(
		url: String,
		consumerKey: String,
		consumerSecret: String? = nil,
		refreshToken: String
	) async throws -> CheckoutAuth {

		guard let url = URL(string: url) else {
			throw URLError(.badURL)
		}

		var queryItems = [
			"grant_type": "refresh_token",
			"client_id": consumerKey,
			"refresh_token": refreshToken
		]
		consumerSecret.map { queryItems["client_secret"] = $0 }

		do {
			let request = try ForceRequest.create(url: url, method: "POST", queryItems: queryItems)
			let auth = try await CheckoutNetworkManager.shared.fetch(type: ForceAuth.self, request: request)
			Logger.debug("Refreshed the access token: \(auth)")

			/// Add back the refreshToken
			let newAuth = CheckoutAuth(accessToken: auth.accessToken,
									instanceURL: auth.instanceURL,
									identityURL: auth.identityURL,
									tokenType: auth.tokenType,
									timestamp: auth.timestamp,
									signature: auth.signature,
									refreshToken: refreshToken)
			try saveAuth(for: newAuth)
			return newAuth

		} catch {
			throw error
		}

	}

	/// Save Auth to Keychain
	public func saveAuth(for auth: CheckoutAuth) throws {
		do {
			try CheckoutAuthKeychainManager.save(item: auth)
			defaults.userIdentifier = auth.identityURL
		} catch {
			throw error
		}
	}

	/// Retrieve Auth from Keychain
	public func retrieveAuth() throws -> CheckoutAuth {
		guard let id = CheckoutAuthManager.shared.userIdentifier else {
			throw CommonError.userIdentityUnknown
		}
		guard let auth = try CheckoutAuthKeychainManager.retrieve(for: id) else {
			throw CommonError.authNotFoundInKeychain
		}
		return auth
	}
}
