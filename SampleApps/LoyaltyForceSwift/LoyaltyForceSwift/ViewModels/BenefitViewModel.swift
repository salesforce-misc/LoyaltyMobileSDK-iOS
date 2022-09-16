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
    @Published var isLoaded = false
    
    func fetchBenefitsOption3(memberId: String) async throws {
        
        do {
            isLoaded = false
            benefits = []
                        
            let result = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId)
            
            await MainActor.run {
                isLoaded = true
                self.benefits = result
            }
            
        } catch {
            throw error
        }

    }
    
}
