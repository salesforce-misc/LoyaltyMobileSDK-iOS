//
//  OnboardingCardModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import Foundation

struct OnboardingModel: Identifiable {
    let id  = UUID()
    let image : String
    let description : String
    
}

var testData: [OnboardingModel] = [
 OnboardingModel(image: "img-preview1", description: "Convert your points into reward coupons!"),
 OnboardingModel(image: "img-preview2", description: "The more points, the more rewards!"),
 OnboardingModel(image: "img-preview3", description: "Get personalized offers, just for you!")
]
