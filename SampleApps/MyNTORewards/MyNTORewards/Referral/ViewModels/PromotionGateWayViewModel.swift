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

@MainActor
class PromotionGateWayViewModel: ObservableObject {
    @Published private(set) var promotionReferralInfo: PromotionInfo?
    @Published private(set) var promotionStatusApiState = LoadingState.idle
    @Published private(set) var isReferralPromotion = false
    @Published private(set) var enrolledToPromotion = false
    @Published private(set) var promoCode = AppSettings.Defaults.promotionCode
    
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
    
    func getPromotionTypeAndStatus(promotionId: String, loyaltyProgramMemberId: String) async {
        promotionStatusApiState = .loading
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT LoyaltyProgramMemberId, LoyaltyProgramMember.ContactId, Promotion.PromotionCode, Promotion.IsReferralPromotion FROM LoyaltyProgramMbrPromotion WHERE PromotionId= '\(promotionId)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            promotionStatusApiState = .loaded
            guard let promotionObject: PromotionObject = try queryResult.records.first?.value(forField: "Promotion") else {
                isReferralPromotion = false
                return
            }
            let status = queryResult.records.first(where: {$0.string(forField: "LoyaltyProgramMemberId") == loyaltyProgramMemberId}) == nil ? false: true
            promotionReferralInfo = PromotionInfo(isReferralPromotion: promotionObject.isReferralPromotion,
                                                  promotionCode: promotionObject.promotionCode, IsEnrolledToPromotion: status)
            isReferralPromotion = promotionObject.isReferralPromotion ?? false
            enrolledToPromotion = status
            promoCode = promotionObject.promotionCode
            
        } catch {
            promotionStatusApiState = .failed(error)
            Logger.error(error.localizedDescription)
        }
    }
    
}
