//
//  PromotionGateWayViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 07/02/24.
//

import Foundation
import ReferralMobileSDK

enum PromotionGateWayScreenState {
    case loyaltyPromotion
    case joinReferralPromotion
    case referFriend
    case joinPromotionError
}

@MainActor
class PromotionGateWayViewModel: ObservableObject {
    @Published private(set) var promotionStatusApiState = LoadingState.idle
    @Published var displayError: (Bool, String) = (false, "")
    @Published var promotionScreenType: PromotionGateWayScreenState = .loyaltyPromotion
    @Published private(set) var promotionInfo: ReferralPromotionObject?
    private let authManager: ForceAuthenticator
    private let forceClient: ForceClient
    private let referralAPIManager: ReferralAPIManager
    private let defaultPromotionCode = AppSettings.Defaults.promotionCode
	
	let devMode: Bool
	let mockPromotionStatusApiState: LoadingState
	let mockPromotionScreenType: PromotionGateWayScreenState
    
    init(
		authManager: ForceAuthenticator = ForceAuthManager.shared,
		forceClient: ForceClient? = nil,
		devMode: Bool = false,
		mockPromotionStatusApiState: LoadingState = .idle,
		mockPromotionScreenType: PromotionGateWayScreenState = .loyaltyPromotion
	) {
            self.authManager = authManager
            self.forceClient = forceClient ?? ForceClient(auth: authManager)
            self.referralAPIManager = ReferralAPIManager(auth: self.authManager,
                                                         referralProgramName: AppSettings.shared.getReferralProgramName(),
                                                         instanceURL: AppSettings.shared.getCommunityURL(),
                                                         forceClient: self.forceClient)
		self.devMode = devMode
		self.mockPromotionStatusApiState = mockPromotionStatusApiState
		self.mockPromotionScreenType = mockPromotionScreenType
        }
    
    func checkEnrollmentStatus(contactId: String, promotionCode: String) async {
		if devMode && mockPromotionStatusApiState == .failed(CommonError.invalidData) {
			promotionStatusApiState = .failed(CommonError.invalidData)
			return
		}
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id, Name, PromotionId, LoyaltyProgramMemberId, LoyaltyProgramMember.ContactId FROM LoyaltyProgramMbrPromotion where LoyaltyProgramMember.ContactId='\(contactId)' AND Promotion.PromotionCode='\(promotionCode)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            promotionStatusApiState = .loaded
            promotionScreenType = !queryResult.records.isEmpty ? .referFriend : .joinReferralPromotion
        } catch {
            promotionStatusApiState = .failed(error)
            Logger.error(error.localizedDescription)
        }
    }
    
    func getPromotionType(promotionId: String, contactId: String) async {
        promotionStatusApiState = .loading
        if !LoyaltyFeatureManager.shared.isReferralFeatureEnabled {
            promotionStatusApiState = .loaded
            promotionScreenType = .loyaltyPromotion
            return
        }
		if devMode && mockPromotionStatusApiState == .failed(CommonError.invalidData) {
			promotionStatusApiState = .failed(CommonError.invalidData)
			return
		} else if devMode && mockPromotionStatusApiState == .loaded && mockPromotionScreenType == .joinPromotionError {
			promotionStatusApiState = .loaded
			displayError = (true, StringConstants.Referrals.genericError)
			promotionScreenType = .joinPromotionError
			return
		}
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id, IsReferralPromotion, PromotionCode, Name, Description, ImageUrl, PromotionPageUrl  FROM Promotion Where Id= '\(promotionId)'"
            let promotion = try await forceClient.SOQL(type: ReferralPromotionObject.self, for: query)
            promotionInfo = promotion.records.first
            if promotionInfo?.isReferralPromotion ?? false {
                await checkEnrollmentStatus(contactId: contactId, promotionCode: promotionInfo?.promotionCode ?? "")
            } else {
                promotionStatusApiState = .loaded
                promotionScreenType = .loyaltyPromotion
            }
        } catch {
            promotionStatusApiState = .failed(error)
            Logger.error(error.localizedDescription)
        }
    }
    
    func enroll(contactId: String) async {
		if devMode && mockPromotionScreenType == .joinPromotionError {
			promotionScreenType = .joinPromotionError
			return
		}
        do {
            let output = try await referralAPIManager.referralEnrollment(contactID: contactId, promotionCode: promotionInfo?.promotionCode ?? "")
            if output.transactionJournals.first?.status.uppercased() == "PROCESSED" || output.transactionJournals.first?.status.uppercased() == "PENDING" {
                promotionScreenType = .referFriend
            } else {
                // status is not `Processed`, if `Pending` should
                Logger.debug("The enrollment status is: \(output.transactionJournals.first?.status ?? "NOTFOUND")")
                displayError = (true, StringConstants.Referrals.enrollmentError)
                promotionScreenType = .joinPromotionError
            }
        } catch CommonError.responseUnsuccessful(_, let errorMessage), CommonError.unknownException(let errorMessage) {
           displayError = (true, errorMessage)
           promotionScreenType = .joinPromotionError
       } catch {
            Logger.error("Referral Enrollment Error: \(error.localizedDescription)")
            displayError = (true, error.localizedDescription)
            promotionScreenType = .joinPromotionError
        }
    }
}
