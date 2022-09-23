//
//  OnboardingCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingCardView: View {
    
    let card : OnboardingModel
    let pageCount: Int
    @Binding var currentPage: Int
    
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
            
            VStack {
                Spacer()
                
                HStack {
                    Image("img-nt-logo")
                    Spacer()
                }
                .padding(.leading, 25)
                
                HStack {
                    Text(card.description)
                        .foregroundColor(Color.white)
                        .font(.onboardingText)
                    Spacer()
                }
                .padding(.leading, 25)
                
                
                // paging indicator
                HStack {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Capsule()
                            .fill(.white)
                            .frame(width: index == currentPage ? 20 : 7, height: 7, alignment: .leading)
                            .animation(.easeInOut, value: index)
                    }
                    Spacer()

                }
                .padding(.leading, 25)
                
                JoinButton()
                Text("Already a member? Sign In")
                    .foregroundColor(Color.white)
                    .padding()
            }
            
        }
    }
}

struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(card: testData[0], pageCount: 3, currentPage: .constant(0))
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

struct JoinButton: View {
    var body: some View {
        
        Text("Join Now")
            .font(.buttonText)
            .foregroundColor(.accentColor)
            .frame(width: 327, height: 48)
            .background(Color.theme.lightButton)
            .cornerRadius(24)
            .padding()
    }
}

