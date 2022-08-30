//
//  BenefitViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftlySalesforce
import SwiftUI

class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    
    func fetchBenefits(connection: Connection) async throws {
        
        do {
            let result = try await connection.rest(
                type: Benefits.self,
                method: "GET",
                version: AppConstants.Config.apiVersion,
                path: "/connect/loyalty/member/0lM5i00000000KlEAI/memberbenefits")
            
            await MainActor.run {
                self.benefits = result.memberBenefits
            }
            
        } catch {
            throw error
        }

    }

}
