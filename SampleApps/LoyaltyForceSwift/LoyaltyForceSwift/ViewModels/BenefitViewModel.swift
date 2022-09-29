//
//  BenefitViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftUI

class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var benefitDescs: [String: String] = [:]
    @Published var isLoaded = false
    
    func getBenefits(memberId: String) async throws {
        
        do {
            isLoaded = false
            benefits = []
                        
            let results: [BenefitModel] = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId)
            try await updateBenefitDescs(benefits: results)

            await MainActor.run {
                isLoaded = true
                self.benefits = results
            }
            
        } catch {
            throw error
        }
    }
    
    func updateBenefitDescs(benefits: [BenefitModel]) async throws {
        
        do {
            let benefitIds = benefits.map { $0.id }
            let results = try await LoyaltyAPIManager.shared.getBenefitRecord(by: benefitIds)
            for result in results {
                guard let id = result.string(forField: "Id"),
                      let desc = result.string(forField: "Description") else {
                    continue
                }
                await MainActor.run {
                    self.benefitDescs[id] = desc
                }
                
            }
        } catch {
            throw error
        }
         
    }
}
