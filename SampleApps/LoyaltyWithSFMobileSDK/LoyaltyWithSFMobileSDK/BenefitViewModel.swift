//
//  BenefitViewModel.swift
//  LoyaltyWithSFMobileSDK
//
//  Created by Leon Qi on 8/30/22.
//  Copyright © 2022 LoyaltyWithSFMobileSDKOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import Combine

class BenefitViewModel: ObservableObject {
    
    @Published var benefits: [BenefitModel] = []
    @Published var isLoaded = false
    private var benefitsCancellable: AnyCancellable?
    
    
    func fetchBenefits(memberId: String) {
        
        let request = RestRequest(
            method: .GET,
            serviceHostType: .instance,
            path: "/v\(AppConstants.Config.apiVersion)/connect/loyalty/member/\(memberId)/memberbenefits",
            queryParams: nil)
        
        benefitsCancellable = RestClient.shared.publisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({ (response) -> Data in
                response.asData()
            })
            .decode(type: Benefits.self, decoder: JSONDecoder())
            .map({ (record) -> [BenefitModel] in
                record.memberBenefits
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }}, receiveValue: { [weak self] (returnedBenefits) in
                self?.benefits = returnedBenefits
                self?.isLoaded = true
                self?.benefitsCancellable?.cancel()
            })
        
/// https://developer.salesforce.com/docs/atlas.en-us.mobile_sdk.meta/mobile_sdk/ios_rest_apis_send_request.htm
//        benefitsCancellable = RestClient.shared.publisher(for: request)
//            .receive(on: RunLoop.main)
//            .tryMap({ (response) -> Data in
//                response.asData()
//            })
//            .decode(type: Benefits.self, decoder: JSONDecoder())
//            .map({ (record) -> [BenefitModel] in
//                record.memberBenefits
//            })
//            .catch({ error in
//                Just([])
//            })
//            .assign(to: \.benefits, on: self)
                
    }

}
