//
//  OfferCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct PromotionCardView: View {

    @EnvironmentObject private var promotionVM: PromotionViewModel
    @State var showPromotionDetailView = false
    @State var processing = false
    let promotion: PromotionResult
    
    var body: some View {
        VStack {
            AsyncImageView(imageUrl: promotion.promotionImageURL)
                .frame(width: 289, height: 154)
                .cornerRadius(5, corners: [.topLeft, .topRight])
                .padding(.top)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(promotion.promotionName)
                        .font(.offerTitle)
                    if let desc = promotion.description {
                        Text(desc)
                            .font(.offerText)
                            .lineSpacing(3)
                    }
                    if let endDate = promotion.endDate {
                        Text("Expiring on **\(endDate)**")
                            .font(.offerText)
                            .padding(.top)
                    }
                    
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .frame(width: 320, height: 340)
        .foregroundColor(.black)
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
        .padding()
            
    }
}

struct PromotionCardView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCardView(promotion: dev.promotion)
            .previewLayout(.sizeThatFits)
    }
}
