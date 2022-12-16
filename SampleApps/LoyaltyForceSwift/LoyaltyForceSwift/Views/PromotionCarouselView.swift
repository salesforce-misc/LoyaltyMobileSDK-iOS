//
//  SampleCarouselView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI

struct PromotionCarouselView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    
    @Binding var selectedTab: Int
    @State var currentIndex: Int = 0
        
    var body: some View {
        VStack {
            HStack {
                Text("Promotions")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                Text("View All")
                    .foregroundColor(Color.theme.accent)
                    .font(.offerViewAll)
                    .onTapGesture {
                        // redirect to My Promotions Tab
                        selectedTab = Tab.offers.rawValue
                    }
            }
            .padding([.top, .leading, .trailing])
            
            if promotionVM.promotions.isEmpty {
                Spacer()
                EmptyStateView(title: "No Promotions, yet.",
                               subTitle: "You do not have any eligibile promotions to enroll. Please come back later.")
                Spacer()
            } else {
                Carousel(index: $currentIndex, items: promotionVM.promotions) { promotion in
                    PromotionCardView(promotion: promotion)
                }

                HStack(spacing: 8){

                    ForEach(promotionVM.promotions.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.theme.accent.opacity(currentIndex == index ? 1 : 0.1))
                            .frame(width: 8, height: 8)
                            //.animation(.spring(), value: currentIndex == index)
                            .animation(.easeInOut, value: currentIndex == index)
                    }
                }
                .padding(.top, -25)
            }

        }
        .frame(height: 450)
        .background(Color.white)
        .task {
            do {
                try await promotionVM.loadCarouselPromotions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Fetch Promotions Error: \(error)")
            }
        }
    }
}

struct PromotionCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCarouselView(selectedTab: .constant(Tab.home.rawValue))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
            .previewLayout(.sizeThatFits)
    }
}

