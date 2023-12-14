//
//  SampleCarouselView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI
import LoyaltyMobileSDK

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
                    .accessibilityIdentifier(AppAccessibilty.Promotion.header)
                Spacer()
                Text("View All")
                    .accessibilityIdentifier(AppAccessibilty.Promotion.viewAll)
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
                EmptyStateView(title: "No promotions yet",
                               subTitle: "When you opt for promotions or have eligible promotions to opt for, you’ll see them here.")
                Spacer()
            } else {
                Carousel(index: $currentIndex, items: promotionVM.promotions) { id, promotion in
                    PromotionCardView(accessibilityID: id, promotion: promotion)
                }

                HStack(spacing: 8) {

                    ForEach(promotionVM.promotions.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.theme.accent.opacity(currentIndex == index ? 1 : 0.1))
                            .frame(width: 8, height: 8)
                            // .animation(.spring(), value: currentIndex == index)
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
                try await promotionVM.loadCarouselPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error("Fetch Promotions Error: \(error)")
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
