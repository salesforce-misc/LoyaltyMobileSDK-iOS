//
//  ProfileView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct ProfileView: View {

    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @EnvironmentObject private var benefitVM: BenefitViewModel
	@EnvironmentObject private var badgesVM: BadgesViewModel
    
    @State var loadRewardPointCardView: Bool = false

    var body: some View {
       
        NavigationStack {
            ZStack {
                Color.white
                
                ScrollView(showsIndicators: false) {
                    profileHeader
                    
                    ZStack {
                        Color.theme.background
                        VStack(spacing: 10) {
                            TransactionsView()
                            VouchersView()
							BadgesView()
                            BenefitView()
                            Rectangle()
                                .frame(height: 400)
                                .foregroundColor(Color.theme.background)
                                .padding(.bottom, -400)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 50)
                        .padding(.top, 20)
                    }
                    
                }
                .refreshable {
                    Logger.debug("Refresh profile view...")
                    Task {
                        do {
                            try await profileVM.fetchProfile(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
                        } catch {
                            Logger.error("Reload Profile Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await transactionVM.reloadTransactions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                        } catch {
                            Logger.error("Reload Transactions Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
							try await voucherVM.loadVouchers(membershipNumber: rootVM.member?.membershipNumber ?? "", reload: true)
                        } catch {
                            Logger.error("Reload Vouchers Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await benefitVM.getBenefits(memberId: rootVM.member?.loyaltyProgramMemberId ?? "", reload: true)
                        } catch {
                            Logger.error("Reload Benefits Error: \(error)")
                        }
                    }
					
					Task {
						do {
							Logger.debug("Profile screen :- Reloading Badges...")
#if DEBUG
							if UITestingHelper.isUITesting {
								try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
																  reload: true, 
																  devMode: true,
																  mockMemberBadgeFileName: UITestingHelper.mockMemberBadgeFileName)
							} else {
								try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "",
																  reload: true)
							}
#else
							try await badgesVM.fetchAllBadges(membershipNumber: rootVM.member?.membershipNumber ?? "", 
															  reload: true)
#endif
							
						} catch {
							Logger.error("Profile screen :- Reload Badges Error: \(error)")
						}
					}
                    
                }
                .offset(y: 40)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Profile")
                            .font(.congratsTitle)
                            .padding(.leading, 15)
                            .accessibilityIdentifier(AppAccessibilty.Profile.header)
                        Spacer()
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    Spacer()
                }
                
            }
            .navigationBarHidden(true)
        }
         
    }
    
    var profileHeader: some View {
        VStack {
            HStack {
                Image("img-profile-adam")
                .clipShape(Circle())
                .accessibilityIdentifier(AppAccessibilty.Profile.image)
                
                VStack {
                    HStack {
                        Text("\(rootVM.member?.firstName ?? "") \(rootVM.member?.lastName ?? "")")
                            .font(.profileTitle)
                            .accessibilityIdentifier(AppAccessibilty.Profile.userName)
                        Spacer()

                    }
                    HStack {
                        Text("Membership Number: \(rootVM.member?.membershipNumber ?? "")")
                            .foregroundColor(Color.theme.textInactive)
                            .font(.profileSubtitle)
                            .accessibilityIdentifier(AppAccessibilty.Profile.userId)
                        Spacer()
                    }
                    
                }

                Spacer()
            }
            .padding()
            
            if loadRewardPointCardView {
                RewardPointsCardView()
                    .environmentObject(profileVM)
            } else {
                ZStack {
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 220)
                            .padding(.horizontal)
                            .foregroundColor(Color.theme.background)
                    }
                    ProgressView()
                }
            }

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                loadRewardPointCardView = true
            }
        }
        .frame(height: 340)
        .background(.white)

    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
            .environmentObject(dev.voucherVM)
            .environmentObject(dev.benefitVM)
            .environmentObject(dev.transactionVM)
    }
}

// Add this for custom navigationLink
extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
