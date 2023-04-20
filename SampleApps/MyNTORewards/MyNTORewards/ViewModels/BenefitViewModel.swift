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
    
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL())
    }
    
    func getBenefits(memberId: String, reload: Bool = false, devMode: Bool = false) async throws {

        isLoaded = false
        if !reload {
            if benefits.isEmpty {
                // get from local cache
                if let cached = localFileManager.getData(type: Benefits.self, id: memberId, folderName: nil) {
                    benefits = cached.memberBenefits
                    benefitsPreview = Array(benefits.prefix(5))
 
                } else {
                    do {
                        try await fetchBenefits(memberId: memberId, devMode: devMode)
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
                try await fetchBenefits(memberId: memberId, devMode: devMode)
            } catch {
                isLoaded = true
                throw error
            }
        }
        isLoaded = true
    }
    
    func fetchBenefits(memberId: String, devMode: Bool = false) async throws {
        
        do {
            let results: [BenefitModel] = try await loyaltyAPIManager.getMemberBenefits(for: memberId, devMode: devMode)
            
            benefits = results
            benefitsPreview = Array(benefits.prefix(5))
            // save to local cache
            let benefitsData = Benefits(memberBenefits: results)
            //LocalFileManager.instance.saveData(item: benefitsData, id: memberId, expiry: .date(Date().addingTimeInterval(60*60)))
            localFileManager.saveData(item: benefitsData, id: memberId, folderName: nil, expiry: .never)
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
