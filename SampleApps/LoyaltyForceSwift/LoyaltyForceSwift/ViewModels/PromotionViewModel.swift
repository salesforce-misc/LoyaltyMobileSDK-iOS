//
//  PromotionViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/31/22.
//

import Foundation

class PromotionViewModel: ObservableObject {

    @Published var allEligiblePromotions: [PromotionResult] = []
    @Published var promotions: [PromotionResult] = []
    @Published var unenrolledPromotions: [PromotionResult] = []
    @Published var activePromotions: [PromotionResult] = []
    
    @MainActor
    func getPromotions(membershipNumber: String) async throws {
        
        if promotions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "PromotionsCarousel") {
                promotions = Array(cached.prefix(5))
            } else {
                do {
                    do {
                        let result = try await LoyaltyAPIManager.shared.getPromotions(membershipNumber: membershipNumber)
                        let allEligible = result.outputParameters.outputParameters.results.filter { result in
                            return result.memberEligibilityCategory != "Ineligible"
                        }
                        // get max of 5 promotions for home page carousel
                        promotions = Array(allEligible.prefix(5))
                        
                        // save to local
                        LocalFileManager.instance.saveData(item: allEligible, id: membershipNumber, folderName: "PromotionsCarousel")
                    } catch {
                        throw error
                    }
                } catch {
                    throw error
                }
                
            }
        }
        
    }
    
    private func fetchPromotions(membershipNumber: String) async throws -> [PromotionResult] {
        do {
            let result = try await LoyaltyAPIManager.shared.getPromotions(membershipNumber: membershipNumber)
            return result.outputParameters.outputParameters.results
        } catch {
            throw error
        }
    }
    
    // fetch all promotions from salesforce
    func fetchAllPromotions(membershipNumber: String) async throws {
        do {
            let promotions = try await fetchPromotions(membershipNumber: membershipNumber)
            let allEligible = promotions.filter { result in
                return result.memberEligibilityCategory != "Ineligible"
            }
            
            await MainActor.run {
                allEligiblePromotions = allEligible
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: allEligible, id: membershipNumber, folderName: "AllPromotions")
            
        } catch {
            throw error
        }
    }
    
    func loadAllPromotions(membershipNumber: String) async throws {

        if allEligiblePromotions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "AllPromotions") {
                await MainActor.run {
                    allEligiblePromotions = cached
                }
            } else {
                do {
                    try await fetchAllPromotions(membershipNumber: membershipNumber)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    // fetch active promotions from salesforce
    func fetchActivePromotions(membershipNumber: String) async throws {
        do {
            let promotions = try await fetchPromotions(membershipNumber: membershipNumber)
            let active = promotions.filter { result in
                return (result.memberEligibilityCategory == "Eligible" || result.promotionEnrollmentRqr == false)
            }
            
            await MainActor.run {
                activePromotions = active
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: active, id: membershipNumber, folderName: "ActivePromotions")
            
        } catch {
            throw error
        }
    }
    
    func loadActivePromotions(membershipNumber: String) async throws {
        
        if activePromotions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "ActivePromotions") {
                await MainActor.run {
                    activePromotions = cached
                }
            } else {
                do {
                    try await fetchActivePromotions(membershipNumber: membershipNumber)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func fetchUnenrolledPromotions(membershipNumber: String) async throws {
        do {
            let promotions = try await fetchPromotions(membershipNumber: membershipNumber)
            let unenrolled = promotions.filter { result in
                return (result.memberEligibilityCategory == "EligibleButNotEnrolled" && result.promotionEnrollmentRqr == true)
            }
            
            await MainActor.run {
                unenrolledPromotions = unenrolled
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: unenrolled, id: membershipNumber, folderName: "UnenrolledPromotions")
            
        } catch {
            throw error
        }
    }
    
    func loadUnenrolledPromotions(membershipNumber: String) async throws {
        
        if unenrolledPromotions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [PromotionResult].self, id: membershipNumber, folderName: "UnenrolledPromotions") {
                await MainActor.run {
                    unenrolledPromotions = cached
                }
            } else {
                do {
                    try await fetchUnenrolledPromotions(membershipNumber: membershipNumber)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func enroll(membershipNumber: String, promotionName: String) async throws {
        do {
            try await LoyaltyAPIManager.shared.enrollIn(promotion: promotionName, for: membershipNumber)
            //try await getPromotions(membershipNumber: membershipNumber)
        } catch {
            throw error
        }
    }
    
    func unenroll(membershipNumber: String, promotionName: String) async throws {
        do {
            try await LoyaltyAPIManager.shared.unenrollIn(promotion: promotionName, for: membershipNumber)
            //try await getPromotions(membershipNumber: membershipNumber)
        } catch {
            throw error
        }
    }
}
