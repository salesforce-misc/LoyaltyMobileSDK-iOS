//
//  LoyaltyFeatureManager.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 19/03/24.
//

import Foundation
import ReferralMobileSDK

final class LoyaltyFeatureManager {
    static let shared = LoyaltyFeatureManager()
    private init() { }
    
    private let forceClient: ForceClient = ForceClient(auth: ForceAuthManager.shared)

    var isReferralFeatureEnabled: Bool = false
    
    public func checkIsReferralFeatureEnabled() {
        Task {
            await getPromotionType()
        }
    }
    
    func getPromotionType() async {
        do {
            let query = "SELECT Id, IsReferralPromotion FROM Promotion Where PromotionCode = '\(AppSettings.Defaults.promotionCode)'"
            let promotion = try await forceClient.SOQL(type: Record.self, for: query)
            isReferralFeatureEnabled = true
        } catch {
            Logger.error(error.localizedDescription)
            isReferralFeatureEnabled = false
        }
    }
}
