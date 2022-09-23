//
//  OnboardingView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var selectedPage = 0
    let onboardingData: [OnboardingModel] = [
        OnboardingModel(image: "img-onboarding1", description: "Convert your points into reward coupons!"),
        OnboardingModel(image: "img-onboarding2", description: "The more points, the more rewards!"),
        OnboardingModel(image: "img-onboarding3", description: "Get personalized offers, just for you!")
       ]
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedPage) {
                let pageCount = onboardingData.count
                ForEach(0..<pageCount, id: \.self) { index in
                    OnboardingCardView(card : onboardingData[index], pageCount: pageCount, currentPage: $selectedPage).tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
