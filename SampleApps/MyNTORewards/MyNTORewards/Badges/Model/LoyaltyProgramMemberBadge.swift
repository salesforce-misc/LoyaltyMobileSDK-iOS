//
//  LoyaltyProgramMemberBadge.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/03/24.
//

import Foundation

struct LoyaltyProgramMemberBadge: Codable, Hashable, Equatable {
	let name: String
	let startDate: Date?
	let endDate: Date?
	let reason: String
	let status: LoyaltyProgramMemberBadgeStatus
	let loyaltyProgramMemberId: String
	let loyaltyProgramBadgeId: String
	
	enum CodingKeys: String, CodingKey {
		case name = "Name"
		case startDate = "StartDate"
		case endDate = "EndDate"
		case reason = "Reason"
		case status = "Status"
		case loyaltyProgramMemberId = "LoyaltyProgramMemberId"
		case loyaltyProgramBadgeId = "LoyaltyProgramBadgeId"
	}
	
	static func == (lhs: LoyaltyProgramMemberBadge, rhs: LoyaltyProgramMemberBadge) -> Bool {
		return lhs.loyaltyProgramBadgeId == rhs.loyaltyProgramBadgeId
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(loyaltyProgramBadgeId)
	}
}

enum LoyaltyProgramMemberBadgeStatus: String, Codable {
	case active = "Active"
	case expired = "Expired"
}
