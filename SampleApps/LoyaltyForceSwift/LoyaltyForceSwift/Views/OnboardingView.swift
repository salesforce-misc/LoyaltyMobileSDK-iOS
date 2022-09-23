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
        let pageCount = onboardingData.count
        ZStack {
            TabView(selection: $selectedPage) {
                ForEach(0..<pageCount, id: \.self) { index in
                    OnboardingCardView(card : onboardingData[index]).tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            VStack {
                Spacer()

                HStack {
                    Image("img-nt-logo")
                    Spacer()
                }
                .padding(.leading, 25)

                HStack {
                    Text( onboardingData[selectedPage].description)
                        .foregroundColor(Color.white)
                        .font(.onboardingText)
                    Spacer()
                }
                .padding(.leading, 25)


                // paging indicator
                HStack(spacing: 4) {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Capsule()
                            .fill(.white)
                            .opacity(index == selectedPage ? 1 : 0.6)
                            .frame(width: index == selectedPage ? 16 : 8, height: 8, alignment: .leading)
                            .animation(.easeInOut, value: index)
                    }
                    Spacer()

                }
                .padding(.leading, 25)
                .padding([.top, .bottom])

                JoinButton()
                Text("Already a member? Sign In")
                    .foregroundColor(Color.white)
                    .padding()
            }

            

        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
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
