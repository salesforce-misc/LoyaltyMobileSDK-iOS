//
//  OfferCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI

struct PromotionCardView: View {

    @State var showPromotionDetailView = false
    let promotion: PromotionResult
    
    var body: some View {
        VStack {
            //Image(promotion.imageUrl ?? "img-placeholder")
            AsyncImageView(imageUrl: promotion.imageUrl ?? "https://picsum.photos/400/600")
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
        .sheet(isPresented: $showPromotionDetailView) {
            MyPromotionDetailView(promotion: promotion)
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
