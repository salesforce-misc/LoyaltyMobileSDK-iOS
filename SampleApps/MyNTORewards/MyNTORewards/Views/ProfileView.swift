//
//  ProfileView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @EnvironmentObject private var benefitVM: BenefitViewModel
    
    @State var loadRewardPointCardView: Bool = false

    var body: some View {
       
        NavigationView {
            ZStack {
                Color.white
                
                ScrollView(showsIndicators: false) {
                    profileHeader
                    
                    ZStack {
                        Color.theme.background
                        VStack(spacing: 10) {
                            TransactionsView()
                            VouchersView()
                            BenefitView()
                            //BadgesView()
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
                    print("Refresh profile view...")
                    Task {
                        do {
                            try await profileVM.fetchProfile(memberId: rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? "")
                        } catch {
                            print("Reload Profile Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await transactionVM.reloadTransactions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
                        } catch {
                            print("Reload Transactions Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await voucherVM.reloadVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
                        } catch {
                            print("Reload Vouchers Error: \(error)")
                        }
                    }
                    
                    Task {
                        do {
                            try await benefitVM.getBenefits(memberId: rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? "", reload: true)
                        } catch {
                            print("Reload Benefits Error: \(error)")
                        }
                    }
                    
                    
                }
                .offset(y: 40)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Profile")
                            .font(.congratsTitle)
                            .padding(.leading, 15)
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
        .navigationViewStyle(.stack)
         
    }
    
    var profileHeader: some View {
        VStack {
            HStack {
                Image("img-profile-adam")
                .clipShape(Circle())
                
                VStack {
                    HStack {
                        Text("\(rootVM.member?.firstName ?? "") \(rootVM.member?.lastName ?? "")")
                            .font(.profileTitle)
                        Spacer()

                    }
                    HStack {
                        Text("Membership Number: \(rootVM.member?.enrollmentDetails.membershipNumber ?? "")")
                            .foregroundColor(Color.theme.textInactive)
                            .font(.profileSubtitle)
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
