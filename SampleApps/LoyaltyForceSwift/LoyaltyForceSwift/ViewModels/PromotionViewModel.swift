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
            
            await MainActor.run {
                // get max of 5 promotions
                promotions = Array(result.outputParameters.outputParameters.results.prefix(5))
            }
            
        } catch {
            throw error
        }
    }
}
