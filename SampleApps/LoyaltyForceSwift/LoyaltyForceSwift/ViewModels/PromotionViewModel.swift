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
            //return result.outputParameters.outputParameters.results
            
            await MainActor.run {
                promotions = result.outputParameters.outputParameters.results
            }
            
        } catch {
            throw error
        }
    }
}
