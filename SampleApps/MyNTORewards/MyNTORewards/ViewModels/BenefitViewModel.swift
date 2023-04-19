//
//  BenefitViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftUI
import LoyaltyMobileSDK

@MainActor
class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var benefitsPreview: [BenefitModel] = []
    @Published var isLoaded = false
    
    private let authManager = ForceAuthManager.shared
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init() {
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL(), forceClient: ForceClient(auth: authManager))
    }
    
    func getBenefits(memberId: String, reload: Bool = false) async throws {

        isLoaded = false
        if !reload {
            if benefits.isEmpty {
                // get from local cache
                if let cached = LocalFileManager.instance.getData(type: Benefits.self, id: memberId) {
                    benefits = cached.memberBenefits
                    benefitsPreview = Array(benefits.prefix(5))
 
                } else {
                    do {
                        try await fetchBenefits(memberId: memberId)
                    } catch {
                        isLoaded = true
                        throw error
                    }
                    
                }

            }
            
        } else {
            benefits = []
            benefitsPreview = []
            
            do {
                try await fetchBenefits(memberId: memberId)
            } catch {
                isLoaded = true
                throw error
            }
        }
        isLoaded = true
    }
    
    private func fetchBenefits(memberId: String) async throws {
        
        do {
            let results: [BenefitModel] = try await loyaltyAPIManager.getMemberBenefits(for: memberId)
            
            benefits = results
            benefitsPreview = Array(benefits.prefix(5))
            // save to local cache
            let benefitsData = Benefits(memberBenefits: results)
            //LocalFileManager.instance.saveData(item: benefitsData, id: memberId, expiry: .date(Date().addingTimeInterval(60*60)))
            LocalFileManager.instance.saveData(item: benefitsData, id: memberId)
        } catch {
            throw error
        }
    }
    
    // clear memory
    func clear() {
        benefits = []
        benefitsPreview = []
    }
    
}
