//
//  UITestingHelper.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 14/12/23.
//

import Foundation

#if DEBUG
struct UITestingHelper {
	static let mockLoadingTimeInSec = 2
	
	static var isUITesting: Bool {
		ProcessInfo.processInfo.arguments.contains("ui_test")
	}
	
	static var isGetGamesSuccess: Bool {
		ProcessInfo.processInfo.environment["get_games"] == "success"
	}
	
	static var isScratchCardPlayGameRewarded: Bool {
		ProcessInfo.processInfo.environment["play_scratch_card"] == "rewarded"
	}
	
	static var isScratchCardPlayGameNoReward: Bool {
		ProcessInfo.processInfo.environment["play_scratch_card"] == "no_reward"
	}
	
	static var isScratchCardPlayGameFail: Bool {
		ProcessInfo.processInfo.environment["play_scratch_card"] == "fail"
	}
	
	static var isSpinAWheelPlayGameRewarded: Bool {
		ProcessInfo.processInfo.environment["play_spin_a_wheel"] == "rewarded"
	}
	
	static var isSpinAWheelPlayGameNoReward: Bool {
		ProcessInfo.processInfo.environment["play_spin_a_wheel"] == "no_reward"
	}
	
	static var isSpinAWheelPlayGameFail: Bool {
		ProcessInfo.processInfo.environment["play_spin_a_wheel"] == "fail"
	}
	
	static var isExpiringToday: Bool {
		ProcessInfo.processInfo.environment["expiry"] == "today"
	}
	
	static var isExpiringTomorrow: Bool {
		ProcessInfo.processInfo.environment["expiry"] == "tomorrow"
	}
	
	static var playGamesMockFileName: String {
		if isScratchCardPlayGameRewarded || isSpinAWheelPlayGameRewarded {
			return "PlayGame_Success"
		} else if isScratchCardPlayGameNoReward || isSpinAWheelPlayGameNoReward {
			return "PlayGame_NoReward"
		} else if isScratchCardPlayGameFail || isSpinAWheelPlayGameFail {
			return "PlayGame_Fail"
		}
		return "PlayGame_Success"
	}
	
	static var getGamesMockFileName: String {
		isGetGamesSuccess ? "GetGames_Success" : "GetGames_Fail"
	}
	
	// Badges
	static var isGetBadgesSuccess: Bool {
		ProcessInfo.processInfo.environment["get_badges"] == "success"
	}
	
	static var mockMemberBadgeFileName: String {
		ProcessInfo.processInfo.environment["mock_member_badge_filename"] ?? "LoyaltyProgramMemberBadges"
	}
	
	static var mockProgramBadgeFileName: String {
		ProcessInfo.processInfo.environment["mock_program_badge_filename"] ?? "LoyaltyProgramBadges"
	}
	
	static var currentDate: Date {
		let dateString = ProcessInfo.processInfo.environment["currect_date"] ?? "2024-03-31"
		return dateString.toDate(withFormat: "yyyy-MM-dd") ?? Date()
	}
}
#endif
