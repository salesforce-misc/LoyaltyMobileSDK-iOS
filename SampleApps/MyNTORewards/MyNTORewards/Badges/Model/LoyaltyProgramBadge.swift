//
//  LoyaltyProgramBadge.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/03/24.
//

import Foundation

struct LoyaltyProgramBadge: Codable {
	let id: String
	let description: String
	let imageUrl: String?
	let loyaltyProgramId: String
	let name: String
	let startDate: Date?
	let status: LoyaltyProgramBadgeStatus
	let validityDuration: Int?
	let validityDurationUnit: String?
	let validityEndDate: Date?
	let validityType: String
	
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case description = "Description"
		case imageUrl = "ImageUrl"
		case loyaltyProgramId = "LoyaltyProgramId"
		case name = "Name"
		case startDate = "StartDate"
		case status = "Status"
		case validityEndDate = "ValidityEndDate"
		case validityType = "ValidityType"
		case validityDurationUnit = "ValidityDurationUnit"
		case validityDuration = "ValidityDuration"
	}
}

enum LoyaltyProgramBadgeStatus: String, Codable {
	case active = "Active"
	case expired = "Expired"
}
