//
//  CheckoutAuth.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation

public struct CheckoutAuth: Codable {
	public let accessToken: String
	public let instanceURL: String
	public let identityURL: String
	public let tokenType: String?
	public let timestamp: String?
	public let signature: String?
	public let refreshToken: String?
	
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case instanceURL = "instance_url"
		case identityURL = "id"
		case tokenType = "token_type"
		case timestamp = "issued_at"
		case signature
		case refreshToken = "refresh_token"
	}
	
	public var host: String {
		guard let url = URL(string: instanceURL) else { return "" }
		guard let host = url.host else { return ""}
		return host
	}
	
	/// The ID of the Salesforce User record associated with this credential.
	public var userID: String {
		guard let url = URL(string: identityURL) else { return "" }
		return url.lastPathComponent
	}
	
	/// The ID of the Salesforce Organization record associated with this credential.
	public var orgID: String {
		guard let url = URL(string: identityURL) else { return "" }
		return url.deletingLastPathComponent().lastPathComponent
	}
}
