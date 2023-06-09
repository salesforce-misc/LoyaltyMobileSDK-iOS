//
//  MyOffersCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct MyPromotionCardView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @State var loadImage: Bool = false
    @State var showPromotionDetailView = false
    @State var processing = false
    let accessibilityID: String
    let promotion: PromotionResult
    
    var body: some View {
        HStack {
            if loadImage {
                AsyncImageView(imageUrl: promotion.promotionImageURL)
                    .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Promotion.image)
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            } else {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                    .overlay {
                        ProgressView()
                    }
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(promotion.promotionName)
                        .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Promotion.name)
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    // Image("ic-heart")
                }
                .padding(.top, 10)
                Text(promotion.description ?? "")
                    .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Promotion.description)
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Spacer()
                    if let expDate = promotion.endDate {
                        Text("Expiring on \(expDate)")
                            .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Promotion.endDate)
                            .font(.labelText)
							.frame(width: 136, height: 19)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .padding(.bottom, 10)
            }
            .padding(.all, 6)
            Spacer()
        }
        .onAppear {
            withAnimation(Animation.spring().delay(0)) {
                loadImage = true
            }
        }
        .frame(width: 343, height: 166)
        .background(Color.white)
        .cornerRadius(10)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(
                    color: Color.gray.opacity(0.4),
                    radius: 10,
                    x: 0,
                    y: 0
                 )
        )
        .onTapGesture {
            showPromotionDetailView.toggle()
        }
        .sheet(isPresented: $showPromotionDetailView, onDismiss: {
            if promotionVM.actionTaskList[promotion.id] != nil {
                promotionVM.actionTaskList[promotion.id]!.1 = true
            } else {
                promotionVM.actionTaskList[promotion.id] = (false, true)
            }
        }) {
			MyPromotionDetailView(promotion: promotion, processing: $processing)
        }
        .onReceive(promotionVM.$actionTaskList) { action in
            if let currentAction = action[promotion.id], currentAction == (true, true) {
                Task {
                    await promotionVM.updatePromotionsFromCache(membershipNumber: rootVM.member?.membershipNumber ?? "", promotionId: promotion.id)
                }
            }
        }
        .allowsHitTesting(!processing)
        .opacity(processing ? 0.5 : 1)
        
    }
}

struct MyPromotionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
            MyPromotionCardView(accessibilityID: "id", promotion: dev.promotion)
                .environmentObject(dev.rootVM)
                .environmentObject(dev.promotionVM)
        }
        
    }
}
