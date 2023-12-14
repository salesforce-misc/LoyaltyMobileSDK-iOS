//
//  OnboardingView.swift
//  MyNTORewards
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
    @State private var showSelfRegister: Bool = false
    @State private var congratsPresented: Bool = false
    @State private var welcomePresented: Bool = false
    @State private var showResetPassword: Bool = false
    @State var showCreateNewPassword: Bool = false
    @State private var showAdminMenu: Bool = false
    @State private var tapCount = 0
    @State private var tapTimer: Timer?
    
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
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    tapCount += 1
                                    
                                    tapTimer?.invalidate() // Invalidate the previous timer
                                    tapTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                                        tapCount = 0
                                    }
                                    
                                    if tapCount == AppSettings.Defaults.adminMenuTapCountRequired {
                                        showAdminMenu = true
                                        tapCount = 0
                                        tapTimer?.invalidate()
                                        tapTimer = nil
                                    }
                                }
                        )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedPage) { _ in
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
                            .accessibility(identifier: AppAccessibilty.Onboarding.pageDescription)
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
                            .offset(x: CGFloat(14 * selectedPage)), alignment: .leading
                    )
                    .padding(.leading, 25)
                    .padding([.top, .bottom])
                }
                .allowsHitTesting(false)

                Button(action: {
                    // signUpPresented.toggle()
                    showSelfRegister = true
                    viewModel.userErrorMessage = ("", ErrorType.noError)
                }, label: {
                    Text("Join")
                })
                .accessibility(identifier: AppAccessibilty.Onboarding.joinButton)
                .buttonStyle(LightLongButton())
                .sheet(isPresented: $signUpPresented) {
                    SignUpView(signInPresented: $signInPresented, signUpPresented: $signUpPresented)
                        .interactiveDismissDisabled()
                        .presentationDetents([.large])
                }
                .sheet(isPresented: $showSelfRegister) {
                    VStack {
                        SheetHeader(title: "Register", onDismiss: {
                            showSelfRegister = false
                        })
                        if let url = URL(string: AppSettings.shared.getConnectedApp().selfRegisterURL) {
                            WebView(url: url,
                                    redirectUrlString: "\(AppSettings.shared.getConnectedApp().communityURL)/apex/CommunitiesLanding",
                                    onDismiss: {
                                        showSelfRegister = false
                                        welcomePresented = true
                            })
                        } else {
                            EmptyStateView(
                                title: "Self Registration Not Available",
                                subTitle: "Sorry, we're having some technical difficulties and self registration is not available.")
                        }
                        Spacer()
                    }
                    .interactiveDismissDisabled()
                    .presentationDetents([.large])

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
                        .accessibility(identifier: AppAccessibilty.Onboarding.alreadyMemberLabel)
                    Button {
                        signInPresented.toggle()
                        viewModel.userErrorMessage = ("", ErrorType.noError)
                    } label: {
                        Text("Log In")
                    }
                    .foregroundColor(.white)
                    .accessibility(identifier: AppAccessibilty.Onboarding.loginButton)
                    .font(.buttonText)
                    .offset(x: -20)
                    .sheet(isPresented: $signInPresented) {
                        SignInView(signInPresented: $signInPresented,
                                   showSelfRegister: $showSelfRegister,
                                   showResetPassword: $showResetPassword)
                            .interactiveDismissDisabled()
                            .presentationDetents([.medium])
                    }
                    .onReceive(viewModel.$userState) { state in
						signInPresented = false
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							if state == UserState.signedIn {
								appViewRouter.signedIn = true
								appViewRouter.currentPage = .navTabsPage()
							}
							signUpPresented = state == UserState.signedInButNotJoined
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
        .sheet(isPresented: $welcomePresented, content: {
            WelcomeView(welcomePresented: $welcomePresented, signInPresented: $signInPresented)
                .interactiveDismissDisabled()
        })
        .sheet(isPresented: $showAdminMenu, onDismiss: {
            showAdminMenu = false
        }) {
            AdminMenuView()
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AppRootViewModel())
    }
}
