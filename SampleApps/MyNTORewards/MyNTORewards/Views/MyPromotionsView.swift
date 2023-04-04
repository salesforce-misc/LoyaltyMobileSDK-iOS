//
//  RewardsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct MyPromotionsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @State var offerTabSelected: Int = 0
    let barItems = ["Unenrolled", "Active", "All"]
    
    var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				VStack(spacing: 0) {
					HStack {
						Text("My Promotions")
							.font(.congratsTitle)
							.padding(.leading, 15)
						Spacer()
						Image("ic-search")
							.padding(.trailing, 15)
					}
					.frame(height: 44)
					.frame(maxWidth: .infinity)
					.background(Color.white)
					TopTabBar(barItems: barItems, tabIndex: $offerTabSelected)
				}
				ZStack {
					Color.theme.background
					
					TabView(selection: $offerTabSelected) {
						
						unenrolledView
							.tag(0)
						activeView
							.tag(1)
						allView
							.tag(2)
						
					}
					.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
					
				}
				.task {
					do {
						try await promotionVM.loadUnenrolledPromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
					} catch {
						print("Load Unenrolled Promotions Error: \(error)")
					}
				}
				.task {
					do {
						try await promotionVM.loadActivePromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
					} catch {
						print("Reload Active Promotions Error: \(error)")
					}
				}
				.task {
					do {
						try await promotionVM.loadAllPromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
					} catch {
						print("Load All Promotions Error: \(error)")
					}
				}
			}
			.background(LoyaltyConditionalNavLink(isActive: $promotionVM.isCheckoutNavigationActive)
						{
				ProductView()
			} label: {
				EmptyView()
			})
		}
        
    }
    
    var unenrolledView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.unenrolledPromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any eligibile promotions to enroll. Please come back later.")
                }
                ForEach(promotionVM.unenrolledPromotions) { promotion in
                    MyPromotionCardView(promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
        }
        .refreshable {
            print("Reloading unenrolled...")
            do {
                try await promotionVM.fetchUnenrolledPromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Reload Unenrolled Promotions Error: \(error)")
            }
        }
    }
    
    var activeView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.activePromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any active promotions. Please come back later.")
                }
                ForEach(promotionVM.activePromotions) { promotion in
                    MyPromotionCardView(promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
        }
        .refreshable {
            print("Reloading active...")
            do {
                try await promotionVM.fetchActivePromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Load Active Promotions Error: \(error)")
            }
        }
        
    }
    
    var allView: some View {
        
        ScrollView {
            LazyVStack(spacing: 15) {
                if promotionVM.allEligiblePromotions.isEmpty {
                    EmptyStateView(title: "No Promotions, yet.",
                                   subTitle: "You do not have any eligibile promotions. Please come back later.")
                }
                ForEach(promotionVM.allEligiblePromotions) { promotion in
                    MyPromotionCardView(promotion: promotion)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
        }
        .refreshable {
            print("Reloading all...")
            do {
                try await promotionVM.fetchAllPromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Reload All Promotions Error: \(error)")
            }
        }
    }
    
}

struct MyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPromotionsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
