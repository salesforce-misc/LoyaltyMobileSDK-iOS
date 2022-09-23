//
//  OnboardingCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingCardView: View {
    
    let card : OnboardingModel
    
    var body: some View {
        ZStack {
            Image(card.image)
                .resizable()
                .ignoresSafeArea()

            VStack {
                Spacer()
                BottomLayer()
            }
            .ignoresSafeArea()
            
        }
    }
}

struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(card: testData[0])
    }
}


struct BottomLayer: View {
    
    var body: some View {

        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0.2690594792366028),
                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0.7582931518554688)]),
                startPoint: UnitPoint(x: 0.49866666211536403, y: 1.0000000062814234),
                endPoint: UnitPoint(x: 0.4986666776940575, y: -0.08012822711649426)))
            .frame(height: 545)
    }
}
