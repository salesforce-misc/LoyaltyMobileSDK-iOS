//
//  PromotionGateWayViewModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 07/02/24.
//

import Foundation
import ReferralMobileSDK

struct PromotionObject: Codable {
    let isReferralPromotion: Bool?
    let promotionCode: String
    enum CodingKeys: String, CodingKey {
        case isReferralPromotion = "IsReferralPromotion"
        case promotionCode = "PromotionCode"
    }
}

struct PromotionInfo {
    let isReferralPromotion: Bool?
    let promotionCode: String
    let IsEnrolledToPromotion: Bool?
}

enum PromotionGateWayScreenState {
    case loyaltyPromotion
    case joinReferralPromotion
    case referFriend
    case joinPromotionError
}

@MainActor
class PromotionGateWayViewModel: ObservableObject {
    @Published private(set) var promotionReferralInfo: PromotionInfo?
    @Published private(set) var promotionStatusApiState = LoadingState.idle
    @Published private(set) var promoCode = AppSettings.Defaults.promotionCode
    @Published var displayError: (Bool, String) = (false, "")
    @Published var promotionScreenType: PromotionGateWayScreenState = .loyaltyPromotion
    
    private var isReferralPromotion = false
    private let authManager: ForceAuthenticator
    private let forceClient: ForceClient
    private let referralAPIManager: ReferralAPIManager
    private let defaultPromotionCode = AppSettings.Defaults.promotionCode
    private let referralProgramName = AppSettings.Defaults.referralProgramName
    
    init(
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil) {
            self.authManager = authManager
            self.forceClient = forceClient ?? ForceClient(auth: authManager)
            self.referralAPIManager = ReferralAPIManager(auth: self.authManager,
                                                         referralProgramName: AppSettings.Defaults.referralProgramName,
                                                         instanceURL: AppSettings.shared.getInstanceURL(),
                                                         forceClient: self.forceClient)
        }
    
    func checkEnrollmentStatus(contactId: String, promotionCode: String) async {
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
        do {
            let query = "SELECT Id, IsReferralPromotion, PromotionCode, Name  FROM Promotion Where Id= '\(promotionId)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            isReferralPromotion = queryResult.records.first?.bool(forField: "IsReferralPromotion") ?? false
            if isReferralPromotion {
                promoCode = queryResult.records.first?.string(forField: "PromotionCode") ?? ""
                await checkEnrollmentStatus(contactId: contactId, promotionCode: promoCode)
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
        do {
            let output = try await referralAPIManager.referralEnrollment(contactID: contactId, promotionCode: promoCode)
            if output.transactionJournals.first?.status.uppercased() == "PROCESSED" {
                promotionScreenType = .referFriend
            } else {
                // status is not `Processed`, if `Pending` should
                Logger.debug("The enrollment status is: \(output.transactionJournals.first?.status ?? "NOTFOUND")")
                displayError = (true, StringConstants.Referrals.enrollmentError)
                promotionScreenType = .joinPromotionError
            }
        } catch {
            Logger.error("Referral Enrollment Error: \(error.localizedDescription)")
            displayError = (true, StringConstants.Referrals.enrollmentError)
            promotionScreenType = .joinPromotionError
        }
    }
}
