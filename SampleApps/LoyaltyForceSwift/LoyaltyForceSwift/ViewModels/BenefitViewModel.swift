//
//  BenefitViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftUI
import Combine

class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var benefitDescs: [String: String] = [:]
    @Published var isLoaded = false
    
    func getBenefits(memberId: String) async throws {
        
        do {
            isLoaded = false
            benefits = []
                        
            let results: [BenefitModel] = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId)
            await updateBenefitDescs(benefits: results)

            await MainActor.run {
                isLoaded = true
                self.benefits = results
            }
            
        } catch {
            throw error
        }
    }
    
    func updateBenefitDescs(benefits: [BenefitModel]) async {
        
        for benefit in benefits {
            let desc = await benefit.getBenefitDescription(benefitId: benefit.id)
            await MainActor.run {
                self.benefitDescs[benefit.id] = desc
            }
        }
    }
}
