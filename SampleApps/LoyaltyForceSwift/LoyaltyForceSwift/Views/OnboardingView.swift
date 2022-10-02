//
//  OnboardingView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @StateObject private var viewModel: OnboardingViewModel
    
    @State private var selectedPage: Int = 0
    @State private var opacityText: Double = 1
    @State private var signUpPresented: Bool = false
    @State private var signInPresented: Bool = false
    
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(image: "img-onboarding1", description: "Convert your points into reward coupons!"),
        OnboardingModel(image: "img-onboarding2", description: "The more points, the more rewards!"),
        OnboardingModel(image: "img-onboarding3", description: "Get personalized offers, just for you!")
       ]
    
    init(appViewRouter: AppViewRouter) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(appViewRouter: appViewRouter))
    }
    
    var body: some View {
        let pageCount = onboardingData.count
        ZStack {
            TabView(selection: $selectedPage) {
                ForEach(0..<pageCount, id: \.self) { index in
                    OnboardingCardView(card: onboardingData[index]).tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedPage) { _ in
                //debugPrint("[a]: new value \(newValue)")
                opacityText = 0
                withAnimation(.easeInOut(duration: 1), {
                    opacityText = 1
                })
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
                    Text(onboardingData[selectedPage].description)
                        .foregroundColor(Color.white)
                        .font(.onboardingText)
                    Spacer()
                }
                .opacity(opacityText)
                .padding(.leading, 25)

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
                    FullSheet {
                        SignUpView(signInPresented: $signInPresented, signUpPresented: $signUpPresented)
                            .environmentObject(viewModel)
                    }
      
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
                        HalfSheet {
                            SignInView(signInPresented: $signInPresented, signUpPresented: $signUpPresented)
                                .environmentObject(viewModel)
                        }
                        
                    }
                }
                
            }

        }
        .sheet(isPresented: $viewModel.signUpSuccesful) {
            CongratsView(email: viewModel.email)
                .interactiveDismissDisabled()
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var appViewRouter = AppViewRouter()
    static var previews: some View {
        OnboardingView(appViewRouter: appViewRouter)
    }
}
