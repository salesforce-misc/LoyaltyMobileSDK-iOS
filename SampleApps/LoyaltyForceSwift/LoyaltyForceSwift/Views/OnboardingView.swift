//
//  OnboardingView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var selectedPage = 0
    @State var signUpPresented: Bool = false
    @State var signInPresented: Bool = false
    
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
                .offset(y: -125)

//                HStack {
//                    Text(onboardingData[selectedPage].description)
//                        .foregroundColor(Color.white)
//                        .font(.onboardingText)
//                    Spacer()
//                }
//                .padding(.leading, 25)

                // paging indicator
                HStack(spacing: 6) {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Capsule()
                            .fill(.white)
                            .opacity(index == selectedPage ? 1 : 0.6)
                            .frame(width: index == selectedPage ? 16 : 8, height: 8, alignment: .leading)
                    }
                    .animation(.easeInOut, value: selectedPage)
                    Spacer()

                }
                .overlay(
                    Capsule()
                        .fill(.white)
                        .frame(width: 16, height: 8)
                        .offset(x: CGFloat(14 * selectedPage)) // 14 = 6 (spacing) + 8 (dot width)
                    , alignment: .leading
                )
                .padding(.leading, 25)
                .padding([.top, .bottom])

                Button(action: {
                    signUpPresented.toggle()
                }, label: {
                    Text("Join Now")
                })
                .buttonStyle(LightLongButton())
                .sheet(isPresented: $signUpPresented) {
                    // present join form
                    SignUpView()
                }


                HStack {
                    Text("Already a member?")
                        .foregroundColor(Color.white)
                        .padding()
                    Button {
                        signInPresented.toggle()
                    } label: {
                        Text("Sign In")
                    }
                    .foregroundColor(.white)
                    .font(.buttonText)
                    .offset(x: -20)
                    .sheet(isPresented: $signInPresented) {
                        // Sign In form
                        SignInView()
                    }

                }
                
            }

        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
