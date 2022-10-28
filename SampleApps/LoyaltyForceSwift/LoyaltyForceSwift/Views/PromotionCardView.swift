//
//  OfferCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI

struct PromotionCardView: View {
    let offer: Offer
    
    var body: some View {
        VStack {
            Image(offer.offerImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 289, height: 154)
                .cornerRadius(5, corners: [.topLeft, .topRight])
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(offer.offerTitle)
                    .font(.offerTitle)
                Text(offer.offerDescription)
                    .font(.offerText)
                    .lineSpacing(3)
                Text("Expiration: **\(offer.offerExpirationDate)**")
                    .font(.offerText)
                    .padding(.top)
            }
            .padding()
            
            Button("Enroll Now") {
                
            }
            .buttonStyle(LightShortButton())
            .padding(.bottom)
        }
        .frame(width: 320, height: 384)
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
        .padding()
            
        
    }
}

struct PromotionCardView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCardView(offer: Offer(offerImage:"offers", offerTitle: "Camping Fun For Entire Family", offerDescription: "The ultimate family camping destination is closer than you might think.", offerExpirationDate: "12/12/2022"))
            .previewLayout(.sizeThatFits)
    }
}
