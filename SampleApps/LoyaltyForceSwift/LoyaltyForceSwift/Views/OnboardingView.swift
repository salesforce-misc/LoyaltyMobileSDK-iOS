//
//  OnboardingView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/21/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    @State private var selectedPage: Int = 0
    @State private var opacityText: Double = 1
    @State private var signUpPresented: Bool = false
    @State private var signInPresented: Bool = false
    @State private var congratsPresented: Bool = false
    @State private var showResetPassword: Bool = false
    @State var showCreateNewPassword: Bool = false
    
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(image: "img-preview0", description: "Redeem your points for exciting vouchers!", offset: CGSize(width: 0, height: 0)),
        OnboardingModel(image: "img-preview2", description: "Earn points to unlock new rewards!", offset: CGSize(width: -80, height: 0)),
        OnboardingModel(image: "img-preview3", description: "Get personalized offers!", offset: CGSize(width: 60, height: 0))
    ]
    
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
                Group {
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
                }
                .allowsHitTesting(false)

                Button(action: {
                    signUpPresented.toggle()
                    viewModel.userErrorMessage = ("", ErrorType.noError)
                }, label: {
                    Text("Join")
                })
                .buttonStyle(LightLongButton())
                .sheet(isPresented: $signUpPresented) {
                    FullSheet {
                        SignUpView(signInPresented: $signInPresented, signUpPresented: $signUpPresented)
                    }
      
                }
                .onReceive(viewModel.$userState) { state in
                    if state == UserState.signedUp {
                        signUpPresented = false
                        congratsPresented = true
                    }
                }
                
                
                HStack {
                    Text("Already a Member?")
                        .foregroundColor(Color.white)
                        .padding()
                        .allowsHitTesting(false)
                    Button {
                        signInPresented.toggle()
                        viewModel.userErrorMessage = ("", ErrorType.noError)
                    } label: {
                        Text("Log In")
                    }
                    .foregroundColor(.white)
                    .font(.buttonText)
                    .offset(x: -20)
                    .sheet(isPresented: $signInPresented) {
                        HalfSheet {
                            SignInView(signInPresented: $signInPresented,
                                       signUpPresented: $signUpPresented,
                                       showResetPassword: $showResetPassword)
                        }
                        
                    }
                    .onReceive(viewModel.$userState) { state in
                        if state == UserState.signedIn {
                            appViewRouter.signedIn = true
                            appViewRouter.currentPage = .navTabsPage(selectedTab: .home)
                        }
                    }
                }
                
            }
            

            if showResetPassword {
                ResetPasswordView(showResetPassword: $showResetPassword, signInPresented: $signInPresented)
                    .transition(.move(edge: .trailing))
            }
            
            if showCreateNewPassword {
                CreateNewPasswordView(showCreateNewPassword: $showCreateNewPassword)
                    .transition(.move(edge: .trailing))
            }
        }
        .sheet(isPresented: $congratsPresented) {
            CongratsView(email: viewModel.email)
                .interactiveDismissDisabled()
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AppRootViewModel())
    }
}
