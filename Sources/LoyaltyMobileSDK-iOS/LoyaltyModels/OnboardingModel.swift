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
    let offset: CGSize
}

var testData: [OnboardingModel] = [
    OnboardingModel(image: "img-preview0", description: "Convert your points into reward coupons!", offset: CGSize(width: 0, height: 0)),
    OnboardingModel(image: "img-preview2", description: "The more points, the more rewards!", offset: CGSize(width: -80, height: 0)),
    OnboardingModel(image: "img-preview3", description: "Get personalized offers, just for you!", offset: CGSize(width: 60, height: 0))
]
