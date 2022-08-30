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
    @Published var isLoaded = false
    
    func fetchBenefits(memberId: String) async throws {
        
        do {
            isLoaded = false
            benefits = []
            let result = try await NetworkManager.connection.rest(
                type: Benefits.self,
                method: "GET",
                version: AppConstants.Config.apiVersion,
                path: "/connect/loyalty/member/\(memberId)/memberbenefits")
            
            await MainActor.run {
                isLoaded = true
                self.benefits = result.memberBenefits
            }
            
        } catch {
            throw error
        }

    }

}
