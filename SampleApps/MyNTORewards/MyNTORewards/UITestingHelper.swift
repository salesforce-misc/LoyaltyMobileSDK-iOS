//
//  UITestingHelper.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 14/12/23.
//

import Foundation
import LoyaltyMobileSDK

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
	
	static var isUserEnrolledForReferral: Bool {
		ProcessInfo.processInfo.environment["isEnrolled"] == "true"
	}
	
	static var referralMockFileName: String {
		"Referrals"
	}
	
	static var mockCurrentDateString: String? {
		ProcessInfo.processInfo.environment["mockDate"]
	}
	
	static var dateFormat: String? {
		ProcessInfo.processInfo.environment["dateFormat"]
	}
	
	static var mockCurrentDate: Date {
		guard let dateString = mockCurrentDateString,
			  let format = dateFormat else {
			return Date()
		}
		return dateString.toDate(withFormat: format) ?? Date()
	}
	
	static var isHavingReferralPromotion: Bool {
		ProcessInfo.processInfo.environment["referral_promotion"] == "true"
	}
	
	static var referralsMockFileName: String {
		if isHavingReferralPromotion {
			return "ReferralPromotions"
		}
		return "ReferralPromotions"
	}
	
	private static func getLoadingState(for stateString: String?) -> LoadingState {
		switch stateString {
		case "loading":
			return .loading
		case "loaded":
			return .loaded
		case "idle":
			return .idle
		case "failed":
			return .failed(CommonError.invalidData)
		default:
			return .idle
		}
	}
	
	static var mockApiState: LoadingState {
		let loadingStateString = ProcessInfo.processInfo.environment["loadingState"]
		return getLoadingState(for: loadingStateString)
	}
	
	static var mockEnrollmentStatusApiState: LoadingState {
		let loadingStateString = ProcessInfo.processInfo.environment["mockEnrollmentStatusApiState"]
		return getLoadingState(for: loadingStateString)
	}
	
	static var mockPromotionStatusApiState: LoadingState {
		let loadingStateString = ProcessInfo.processInfo.environment["mockPromotionStatusApiState"]
		return getLoadingState(for: loadingStateString)
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
	
	static var mockPromotionScreenType: PromotionGateWayScreenState {
		let screenState = ProcessInfo.processInfo.environment["mockPromotionScreenType"]
		switch screenState {
		case "loyaltyPromotion":
			return .loyaltyPromotion
		case "joinReferralPromotion":
			return .joinReferralPromotion
		case "referFriend":
			return .referFriend
		case "joinPromotionError":
			return .joinPromotionError
		default:
			return .loyaltyPromotion
		}
		
	}
}
#endif
