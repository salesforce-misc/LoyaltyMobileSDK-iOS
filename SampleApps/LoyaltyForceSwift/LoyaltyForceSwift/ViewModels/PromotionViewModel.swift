//
//  PromotionViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/31/22.
//

import Foundation

class PromotionViewModel: ObservableObject {

    @Published var promotions: [PromotionResult] = []
    
    func getPromotions(membershipNumber: String) async throws {
        
        do {
            let result = try await LoyaltyAPIManager.shared.getPromotions(membershipNumber: membershipNumber, devMode: true)
            let eligibleResult = result.outputParameters.outputParameters.results.filter { result in
                return result.memberEligibilityCategory != "Ineligible"
            }
            await MainActor.run {
                // get max of 5 promotions
                promotions = Array(eligibleResult.prefix(5))
            }
            
        } catch {
            throw error
        }
    }
    
    func enroll(membershipNumber: String, promotionName: String) async throws {
        do {
            try await LoyaltyAPIManager.shared.enrollIn(promotion: promotionName, for: membershipNumber)
            try await getPromotions(membershipNumber: membershipNumber)
        } catch {
            throw error
        }
    }
}
