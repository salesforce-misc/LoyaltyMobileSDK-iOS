//
//  PromotionViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/31/22.
//

import Foundation
import LoyaltyMobileSDK

class PromotionViewModel: ObservableObject {

    @Published var allEligiblePromotions: [PromotionResult] = []
    @Published var promotions: [PromotionResult] = []
    @Published var unenrolledPromotions: [PromotionResult] = []
    @Published var activePromotions: [PromotionResult] = []
    @Published var promotionList: [String: PromotionResult] = [:]
    // To record action(enroll/unenroll) status on enrollable promotions
    // The tuple represents(isActionDone: Bool, isModalDismissed: Bool)
    // actionTaskList => [promotionId: (isActionDone, isModalDismissed)]
    @Published var actionTaskList: [String: (Bool, Bool)] = [:]
	@Published var isCheckoutNavigationActive = false
    
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL(), forceClient: ForceClient(auth: authManager))
    }
    
    // Network call to fetch all eligible promotions
    private func fetchEligiblePromotions(membershipNumber: String, devMode: Bool = false) async throws -> [PromotionResult] {
        do {
            let result = try await loyaltyAPIManager.getPromotions(membershipNumber: membershipNumber, devMode: devMode)
            let eligible = result.outputParameters.outputParameters.results.filter { result in
                return result.memberEligibilityCategory != "Ineligible"
            }
            // save to local
            localFileManager.saveData(item: eligible, id: membershipNumber, folderName: "Promotions", expiry: .never)
            
            await MainActor.run {
                // update promotion list
                promotionList = Dictionary(uniqueKeysWithValues: eligible.map { ($0.id, $0) })
            }

            return eligible
        } catch {
            throw error
        }
    }
    
    func fetchCarouselPromotions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let eligible = try await fetchEligiblePromotions(membershipNumber: membershipNumber, devMode: devMode)
            
            await MainActor.run {
                // get max of 5 promotions for home page carousel
                promotions = Array(eligible.prefix(5))
            }
        } catch {
            throw error
        }
    }
    
    func loadCarouselPromotions(membershipNumber: String, devMode: Bool = false) async throws {
        
        if promotions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "Promotions") {
                await MainActor.run {
                    promotions = Array(cached.prefix(5))
                }
                
            } else {
                do {
                    try await fetchCarouselPromotions(membershipNumber: membershipNumber, devMode: devMode)
                } catch {
                    throw error
                }
            }
        }
        
    }
    
    // fetch all promotions from salesforce
    func fetchAllPromotions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let allEligible = try await fetchEligiblePromotions(membershipNumber: membershipNumber, devMode: devMode)
            
            await MainActor.run {
                allEligiblePromotions = allEligible
            }
            
        } catch {
            throw error
        }
    }
    
    func loadAllPromotions(membershipNumber: String, devMode: Bool = false) async throws {

        if allEligiblePromotions.isEmpty {
            // load from local cache
            if let cached = localFileManager.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "Promotions") {
                await MainActor.run {
                    allEligiblePromotions = cached
                }
            } else {
                do {
                    try await fetchAllPromotions(membershipNumber: membershipNumber, devMode: devMode)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    // fetch active promotions from salesforce
    func fetchActivePromotions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let promotions = try await fetchEligiblePromotions(membershipNumber: membershipNumber, devMode: devMode)
            let active = promotions.filter { result in
                return (result.memberEligibilityCategory == "Eligible" || result.promotionEnrollmentRqr == false)
            }
            
            await MainActor.run {
                activePromotions = active
            }
            
        } catch {
            throw error
        }
    }
    
    func loadActivePromotions(membershipNumber: String, devMode: Bool = false) async throws {
        
        if activePromotions.isEmpty {
            // load from local cache
            if let cached = localFileManager.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "Promotions") {
                let active = cached.filter { result in
                    return (result.memberEligibilityCategory == "Eligible" || result.promotionEnrollmentRqr == false)
                }
                await MainActor.run {
                    activePromotions = active
                }
            } else {
                do {
                    try await fetchActivePromotions(membershipNumber: membershipNumber, devMode: devMode)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func fetchUnenrolledPromotions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let promotions = try await fetchEligiblePromotions(membershipNumber: membershipNumber, devMode: devMode)
            let unenrolled = promotions.filter { result in
                return (result.memberEligibilityCategory == "EligibleButNotEnrolled" && result.promotionEnrollmentRqr == true)
            } 
            
            await MainActor.run {
                unenrolledPromotions = unenrolled
            }
            
        } catch {
            throw error
        }
    }
    
    func loadUnenrolledPromotions(membershipNumber: String, devMode: Bool = false) async throws {
        
        if unenrolledPromotions.isEmpty {
            // load from local cache
            if let cached = localFileManager.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "Promotions") {
                let unenrolled = cached.filter { result in
                    return (result.memberEligibilityCategory == "EligibleButNotEnrolled" && result.promotionEnrollmentRqr == true)
                }
                await MainActor.run {
                    unenrolledPromotions = unenrolled
                }
            } else {
                do {
                    try await fetchUnenrolledPromotions(membershipNumber: membershipNumber, devMode: devMode)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func enroll(membershipNumber: String, promotionName: String, promotionId: String) async throws {
        do {
            try await loyaltyAPIManager.enrollIn(promotion: promotionName, for: membershipNumber)
            // fetch all from network
            _ = try await fetchEligiblePromotions(membershipNumber: membershipNumber)
            await MainActor.run {
                if actionTaskList[promotionId] != nil {
                    actionTaskList[promotionId]!.0 = true
                } else {
                    actionTaskList[promotionId] = (true, false)
                }
                
            }
        } catch {
            throw error
        }
    }
    
    func unenroll(membershipNumber: String, promotionName: String, promotionId: String) async throws {
        do {
			try await loyaltyAPIManager.unenroll(promotionId: promotionId, for: membershipNumber)
            _ = try await fetchEligiblePromotions(membershipNumber: membershipNumber)
            await MainActor.run {
                if actionTaskList[promotionId] != nil {
                    actionTaskList[promotionId]!.0 = true
                } else {
                    actionTaskList[promotionId] = (true, false)
                }
            }
        } catch {
            throw error
        }
    }
    
    func updatePromotionsFromCache(membershipNumber: String, promotionId: String) async {

        guard let cached = localFileManager.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "Promotions") else {
            return
        }
        let active = cached.filter { result in
            return (result.memberEligibilityCategory == "Eligible" || result.promotionEnrollmentRqr == false)
        }
        let unenrolled = cached.filter { result in
            return (result.memberEligibilityCategory == "EligibleButNotEnrolled" && result.promotionEnrollmentRqr == true)
        }
        await MainActor.run {
            activePromotions = active
            unenrolledPromotions = unenrolled
            actionTaskList.removeValue(forKey: promotionId)
        }

    }
    
    @MainActor
    func clear() {
        allEligiblePromotions = []
        promotions = []
        unenrolledPromotions = []
        activePromotions = []
        promotionList = [:]
    }
}
