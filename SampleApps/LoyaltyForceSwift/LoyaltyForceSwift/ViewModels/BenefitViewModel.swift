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
    
    private let benefitCache = Cache<String, [BenefitModel]>()
    private let benefitDescCache = Cache<String, String>()
    
    func getBenefits(memberId: String, reload: Bool = false) async throws {
        
        var descReload = false
        do {
            isLoaded = false
            benefits = []
            benefitsPreview = []
            if reload {
                benefitCache.removeValue(forKey: memberId)
                descReload = true
            }
            
            guard let cached = benefitCache[memberId] else {
                let results: [BenefitModel] = try await LoyaltyAPIManager.shared.getMemberBenefits(for: memberId, devMode: true) // use json for testing
                let ids = results.map { $0.id }
                try await updateBenefitDescs(benefitIds: ids, reload: descReload)
                benefitCache[memberId] = results
                isLoaded = true
                benefits = results
                benefitsPreview = Array(results.prefix(5))
//                let ids = benefits.map { $0.id }
//                try await updateBenefitDescs(benefitIds: ids)
                return
            }
            isLoaded = true
            benefits = cached
            benefitsPreview = Array(cached.prefix(5))
            
        } catch {
            throw error
        }
    }
    
    func updateBenefitDescs(benefitIds: [String], reload: Bool = false) async throws {
        
        var uncachedIds: [String] = []
        
        for id in benefitIds {
            if let cached = benefitDescCache[id] {
                if reload {
                    benefitDescCache.removeValue(forKey: id)
                    uncachedIds.append(id)
                } else {
                    benefitDescs[id] = cached
                }
                
            } else {
                uncachedIds.append(id)
            }
        }

        do {
            if uncachedIds != [] {
                let results = try await LoyaltyAPIManager.shared.getBenefitRecord(by: uncachedIds)
                for result in results {
                    guard let id = result.string(forField: "Id"),
                          let desc = result.string(forField: "Description") else {
                        continue
                    }
                    benefitDescs[id] = desc
                    benefitDescCache[id] = desc
                }
            }
            
        } catch {
            throw error
        }
         
    }
    
//    func updateBenefitDescs(benefits: [BenefitModel]) async throws {
//
//        var uncachedIds = [String]()
//
//        let benefitIds = benefits.map { $0.id }
//        for id in benefitIds {
//            if let cached = benefitDescCache[id] {
//                benefitDescs[id] = cached
//            } else {
//                uncachedIds.append(id)
//            }
//        }
//
//        do {
//            let results = try await LoyaltyAPIManager.shared.getBenefitRecord(by: uncachedIds)
//            for result in results {
//                guard let id = result.string(forField: "Id"),
//                      let desc = result.string(forField: "Description") else {
//                    continue
//                }
//                benefitDescs[id] = desc
//            }
//        } catch {
//            throw error
//        }
//
//    }
    
}
