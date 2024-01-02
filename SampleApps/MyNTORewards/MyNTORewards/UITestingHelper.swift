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
	
	static var isSpinAWheelPlayGameRewardedWithPoints: Bool {
		ProcessInfo.processInfo.environment["play_spin_a_wheel"] == "rewarded_with_points"
	}
	
	static var isSpinAWheelPlayGameRewardedWithoutPoints: Bool {
		ProcessInfo.processInfo.environment["play_spin_a_wheel"] == "rewarded_without_points"
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
		if isScratchCardPlayGameRewarded || isSpinAWheelPlayGameRewardedWithPoints {
			return "PlayGame_Success"
		} else if isSpinAWheelPlayGameRewardedWithoutPoints {
			return "PlayGame_Success_WithoutRewardValue"
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
}
#endif
