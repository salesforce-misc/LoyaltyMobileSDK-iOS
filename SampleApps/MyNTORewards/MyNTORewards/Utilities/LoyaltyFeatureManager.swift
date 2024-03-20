//
//  LoyaltyFeatureManager.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 19/03/24.
//

import Foundation
import ReferralMobileSDK

@MainActor final class LoyaltyFeatureManager: ObservableObject {
    static let shared = LoyaltyFeatureManager()
    private init() { }
    
    private let forceClient: ForceClient = ForceClient(auth: ForceAuthManager.shared)

    @Published public var isReferralFeatureEnabled: Bool = false
    
    public func checkIsReferralFeatureEnabled() {
        Task {
            await getPromotionType()
        }
    }
    
    func getPromotionType() async {
        do {
             let query = "SELECT FIELDS(ALL) FROM Promotion LIMIT 1"
             let promotion = try await forceClient.SOQL(type: Record.self, for: query)
             let isColumnExists = promotion.records.first?.hasField(named: "IsReferralPromotion") ?? false
             isReferralFeatureEnabled = isColumnExists
        } catch {
            Logger.error(error.localizedDescription)
            isReferralFeatureEnabled = false
        }
    }
}
