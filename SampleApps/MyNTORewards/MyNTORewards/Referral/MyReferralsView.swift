//
//  MyReferralsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/20/23.
//

import SwiftUI

struct MyReferralsView: View {
    
    @State private var tabIndex = 0
    @State var showReferAFriendView = false
    var tabbarItems = ["Success", "In Progress"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Referrals")
                    .font(.congratsTitle)
                    .padding(.leading, 15)
                    .accessibilityIdentifier(AppAccessibilty.Referrals.referralsViewTitle)
                Spacer()
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(.white)
            
            ZStack {
                Color.theme.backgroundPink
                
                ScrollView {
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 328, height: 204)
                                .cornerRadius(10, corners: .allCorners)
                                .foregroundColor(Color.theme.referralCardBackground)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("**YOUR REFERRALS**: Last 90 Days")
                                        .font(.referralText)
                                        .padding(10)
                                    Spacer()
                                }
                                
                                HStack(spacing: 30) {
                                    VStack(alignment: .leading) {
                                        Text("SENT")
                                            .font(.referralText)
                                        Text("**18**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text("VOUCHERS EARNED")
                                            .font(.referralText)
                                        Text("**12**")
                                            .font(.referralBoldText)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("ACCEPTED")
                                            .font(.referralText)
                                        Text("**12**")
                                            .font(.referralBoldText)
                                            .padding(.bottom)
                                        Text("POINTS EARNED")
                                            .font(.referralText)
                                        Text("**1200**")
                                            .font(.referralBoldText)
                                    }
                                }
                                .padding(.leading, 30)
                                
                                HStack {
                                    Spacer()
                                    Button("Refer a Friend Now!") {
                                        // Refer
                                        showReferAFriendView.toggle()
                                    }
                                    .buttonStyle(LightShortReferralsButton())
                                    Spacer()
                                }
                                .padding(.bottom, 10)

                            }
                            .foregroundColor(Color.white)
                            .frame(width: 328, height: 204)
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-1")
                                    .padding(.top, 6)
                                    .padding(.trailing, 8)
                                
                            }
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-2")
                                    .padding(.top, 13)
                                    .padding(.trailing, 34)
                            }
                            .overlay(alignment: .topTrailing) {
                                Image("ic-star-3")
                                    .padding(.top, 44)
                                    .padding(.trailing, 10)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-4")
                                    .padding(.top, 48)
                                    .padding(.leading, 8)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-5")
                                    .padding(.top, 52)
                                    .padding(.leading, 41)
                            }
                            .overlay(alignment: .topLeading) {
                                Image("ic-star-6")
                                    .padding(.top, 130)
                                    .padding(.leading, 13)
                            }
                            
                        }
                        .padding()
                        
                        TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
                        
                        TabView(selection: $tabIndex) {
                            SuccessView()
                                .tag(0)
                            InProcessView()
                                .tag(1)
                        }
                        .frame(height: 1000)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showReferAFriendView) {
            ReferAFriendView()
        }
    }
}

struct SuccessView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Referrals")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            Text("Referrals one month ago")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            Text("Referrals older than three month")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .purchaseCompleted, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            Spacer()
        }
    }
}

struct InProcessView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Referrals")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .signedUp, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .pending, email: "shah.verma@gmail.com", referralDate: Date())
            ReferralCard(status: .signedUp, email: "shah.verma@gmail.com", referralDate: Date())
            Text("Referrals one month ago")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .signedUp, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .pending, email: "shah.verma@gmail.com", referralDate: Date())
            ReferralCard(status: .signedUp, email: "shah.verma@gmail.com", referralDate: Date())
            Text("Referrals older than three month")
                .font(.referralTimeTitle)
                .padding(.vertical, 5)
            ReferralCard(status: .signedUp, email: "strawberry.sheikh@yahoo.com", referralDate: Date())
            ReferralCard(status: .pending, email: "shah.verma@gmail.com", referralDate: Date())
            ReferralCard(status: .signedUp, email: "shah.verma@gmail.com", referralDate: Date())
            Spacer()
        }
    }
}

enum ReferralStatus: String {
    case pending = "Pending"
    case signedUp = "Signed-up"
    case purchaseCompleted = "Purchase Completed"
}

struct ReferralCard: View {
    let status: ReferralStatus
    let email: String
    let referralDate: Date
    
    var body: some View {
        VStack {
            HStack {
                Assets.getReferralStatusIcon(status: status)
                Text("**\(email)**")
                    .font(.referralCardText)
                Spacer()
            }
            .padding(.horizontal, 10)
            HStack {
                Text(referralDate.toString())
                    .font(.referralCardText)
                Spacer()
                Text("**\(status.rawValue)**")
                    .font(.referralStatus)
                    .foregroundColor(status == .purchaseCompleted ? Color.theme.purchaseCompleted : .black)
            }
            .padding(.leading, 44)
            .padding(.trailing, 10)
        }
        .frame(width: 343, height: 66)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    MyReferralsView()
}
