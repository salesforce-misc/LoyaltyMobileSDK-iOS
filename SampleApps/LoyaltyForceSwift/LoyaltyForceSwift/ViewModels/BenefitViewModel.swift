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
    @Published var benefitsPreview: [BenefitModel] = []
    @Published var benefitDescs: [String: String] = [:]
    @Published var isLoaded = false
    
    @MainActor
    func getBenefits(memberId: String) async throws {
        
        do {

            isLoaded = false
            benefits = []
            benefitsPreview = []

            let results: [BenefitModel] = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId)
            try await updateBenefitDescs(benefits: results)

            isLoaded = true
            benefits = results
            benefitsPreview = Array(results.prefix(5))

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
                    benefitDescs[id] = desc
                }
                
            }
        } catch {
            throw error
        }
         
    }
}
