//
//  ProfileView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    
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
                            BadgesView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 50)
                    }
                    
                }
                .refreshable {
                    print("Refresh content...")
                    do {
                        try await profileVM.fetchProfile(memberId: rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? "")
                    } catch {
                        print("Reload profile Error: \(error)")
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
                Image("img-profile-larger")
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
            
            RewardPointsCardView()
                .environmentObject(profileVM)
            
            Spacer()
        }
        .frame(height: 360)
        .background(.white)

    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
    }
}

// Add this for custom navigationLink
extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
