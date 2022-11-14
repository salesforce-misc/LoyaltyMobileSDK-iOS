//
//  PromotionDetailView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/11/22.
//

import SwiftUI

struct PromotionDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var currentIndex: Int
    let offers = [
        Offer(offerImage:"offers", offerTitle: "Camping Fun For Entire Family", offerDescription: "The ultimate family camping destination is closer than you might think.", offerExpirationDate: "12/12/2022"),
        Offer(offerImage:"promotion1", offerTitle: "Outdoor Fun for the Family", offerDescription: "The nature is calling for a unforgetable retreat for the whole family.", offerExpirationDate: "12/31/2022"),
        Offer(offerImage:"promotion2", offerTitle: "A Vacation in Hawaii", offerDescription: "The ultimate family vacation is closer than you might think.", offerExpirationDate: "01/15/2023"),
        Offer(offerImage:"promotion3", offerTitle: "Disneyland for Family of 4", offerDescription: "The ultimate family vacation destination is not a dream anymore", offerExpirationDate: "01/31/2023")
    ]
    
    var body: some View {
        
        let offer = offers[currentIndex]
        
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                Image(offer.offerImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .overlay(alignment: .topTrailing) {
                        Image("ic-dismiss")
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(offer.offerTitle)
                        .font(.voucherTitle)

                    Text("**Details**\n\(offer.offerDescription)")
                        .font(.voucherText)
                        .foregroundColor(Color.theme.superLightText)
                        .lineSpacing(5)
                    
                    Text("Expiring on **\(offer.offerExpirationDate)**")
                        .font(.voucherText)
                        .foregroundColor(Color.theme.superLightText)
                    
//                    Text("**Terms and Conditions**\n\(offer.offerDescription)")
//                        .font(.voucherText)
//                        .foregroundColor(Color.theme.superLightText)
//                        .lineSpacing(5)
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Join") {
                            // enroll to the promotion
                        }
                        .buttonStyle(DarkShortButton())
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .zIndex(3.0)
        
    }
}

struct PromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionDetailView(currentIndex: .constant(1))
    }
}
