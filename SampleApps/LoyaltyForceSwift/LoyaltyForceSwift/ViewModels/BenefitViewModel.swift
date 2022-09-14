//
//  BenefitViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import SwiftUI
import Combine

class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var isLoaded = false
    private var benefitsCancellable: AnyCancellable?
    
//    // ForceSwift Option 1: @escaping closure
//    func fetchBenefitsOption1(memberId: String) throws {
//
//        do {
//            isLoaded = false
//            benefits = []
//
//            let request = try ForceRequest.create(
//            method: "GET",
//            path: ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits"))
//
//            ForceClient.shared.fetch(type: Benefits.self, with: request) { (returnedData) in
//                if let data = returnedData {
//                    guard let result = try? JSONDecoder().decode(Benefits.self, from: data) else { return }
//                    DispatchQueue.main.async { [weak self] in
//                        self?.isLoaded = true
//                        self?.benefits = result.memberBenefits
//                    }
//                } else {
//                    print("No data returned.")
//                }
//            }
//
//        }
//        catch {
//            throw error
//        }
//
//    }
    
//    // ForceSwift Option 2: Combine
//    func fetchBenefitsOption2(memberId: String) throws {
//
//        do {
//            isLoaded = false
//            benefits = []
//
//            let request = try ForceRequest.create(
//            method: "GET",
//            path: ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits"))
//
//            benefitsCancellable = ForceClient.shared.fetch(type: Benefits.self, with: request)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print("fetchBenefitsOption2: \(error.localizedDescription)")
//                    }}, receiveValue: { [weak self] (returnedBenefits) in
//                        self?.benefits = returnedBenefits.memberBenefits
//                    self?.isLoaded = true
//                    self?.benefitsCancellable?.cancel()
//                })
//
//        } catch {
//            throw error
//        }
//
//    }
    
    // ForceSwift Option 3: Async/Await
    func fetchBenefitsOption3(memberId: String) async throws {
        
        do {
            isLoaded = false
            benefits = []
                        
            let request = try ForceRequest.create(
                method: "GET",
                path: ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits"))
            
            let result = try await ForceClient.shared.fetch(type: Benefits.self, with: request)
            
            await MainActor.run {
                isLoaded = true
                self.benefits = result.memberBenefits
            }
            
        } catch {
            throw error
        }

    }
    
}
