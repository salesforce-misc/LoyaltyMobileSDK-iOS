//
//  SampleCarouselView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI

struct Offer: Identifiable{
    let id = UUID().uuidString
    let offerImage: String
    let offerTitle: String
    let offerDescription: String
    let offerExpirationDate: String
}

struct PromotionCarouselView: View {

    let offers = [
        Offer(offerImage:"offers", offerTitle: "Camping Fun For Entire Family", offerDescription: "The ultimate family camping destination is closer than you might think.", offerExpirationDate: "12/12/2022"),
        Offer(offerImage:"promotion1", offerTitle: "Outdoor Fun for the Family", offerDescription: "The nature is calling for a unforgetable retreat for the whole family.", offerExpirationDate: "12/31/2022"),
        Offer(offerImage:"promotion2", offerTitle: "A Vacation in Hawaii", offerDescription: "The ultimate family vacation is closer than you might think.", offerExpirationDate: "01/15/2023"),
        Offer(offerImage:"promotion3", offerTitle: "Disneyland for Family of 4", offerDescription: "The ultimate family vacation destination is not a dream anymore", offerExpirationDate: "01/31/2023")
    ]

    @State var currentIndex: Int = 0
        
    var body: some View {
        VStack {
            HStack {
                Text("Offers & Promotions")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                Text("View All")
                    .foregroundColor(Color.theme.accent)
                    .font(.offerViewAll)
                    .onTapGesture {
                        // All offers View
                    }
            }
            .padding()
            
            Carousel(index: $currentIndex, items: offers) { offer in
                PromotionCardView(offer: offer)
            }
            
            HStack(spacing: 8){
                
                ForEach(offers.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.theme.accent.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 8, height: 8)
                        //.animation(.spring(), value: currentIndex == index)
                        .animation(.easeInOut, value: currentIndex == index)
                }
            }
            .padding(.top, -40)
        }
        .frame(height: 540)
        .background(Color.white)
    }
}

struct PromotionCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCarouselView()
            .previewLayout(.sizeThatFits)
    }
}

