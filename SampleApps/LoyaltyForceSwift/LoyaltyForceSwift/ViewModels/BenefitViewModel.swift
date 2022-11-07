//
//  BenefitViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftUI

@MainActor
class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var benefitsPreview: [BenefitModel] = []
    @Published var benefitDescs: [String: String] = [:]
    @Published var isLoaded = false
    
    func getBenefits(memberId: String, reload: Bool = false) async throws {
        var descReload = false
        isLoaded = false
        if !reload {
            if benefits.isEmpty {
                // get from local cache
                if let cached = LocalFileManager.instance.getData(type: Benefits.self, id: memberId) {
                    benefits = cached.memberBenefits
                    benefitsPreview = Array(benefits.prefix(5))
                    do {
                        // get benefit description
                        let ids = benefits.map { $0.id }
                        try await updateBenefitDescs(benefitIds: ids, reload: descReload)
                    } catch {
                        isLoaded = true
                        throw error
                    }
 
                } else {
                    do {
                        try await fetchBenefits(memberId: memberId, reloadDescription: descReload)
                    } catch {
                        isLoaded = true
                        throw error
                    }
                    
                }

            }
            
        } else {
            descReload = true
            benefits = []
            benefitsPreview = []
            
            do {
                try await fetchBenefits(memberId: memberId, reloadDescription: descReload)
            } catch {
                isLoaded = true
                throw error
            }
        }
        isLoaded = true
    }
    
    private func fetchBenefits(memberId: String, reloadDescription: Bool) async throws {
        
        do {
            let results: [BenefitModel] = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId, devMode: true)
            // update benefit description for each benefit
            let ids = results.map { $0.id }
            try await updateBenefitDescs(benefitIds: ids, reload: reloadDescription)
            
            benefits = results
            benefitsPreview = Array(benefits.prefix(5))
            // save to local cache
            let benefitsData = Benefits(memberBenefits: results)
            LocalFileManager.instance.saveData(item: benefitsData, id: memberId)
        } catch {
            throw error
        }
    }
    
    private func updateBenefitDescs(benefitIds: [String], reload: Bool = false) async throws {
        
        var uncachedIds: [String] = []

        do {
            for id in benefitIds {
                
                if reload {
                    uncachedIds.append(id)
                } else {
                    if let cached = LocalFileManager.instance.getData(type: String.self, id: id, folderName: "BenefitDescription") {
                        benefitDescs[id] = cached
                    } else {
                        uncachedIds.append(id)
                    }
                }
                
            }
            
            if uncachedIds != [] {
                let results = try await LoyaltyAPIManager.shared.getBenefitRecord(by: uncachedIds)
                for result in results {
                    guard let id = result.string(forField: "Id"),
                          let desc = result.string(forField: "Description") else {
                        continue
                    }
                    benefitDescs[id] = desc
                    // save to local cache
                    LocalFileManager.instance.saveData(item: desc, id: id, folderName: "BenefitDescription")
                }
            }
            
        } catch {
            throw error
        }
         
    }
    

    
}
