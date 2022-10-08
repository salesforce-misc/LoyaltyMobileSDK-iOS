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

struct SampleCarouselView: View {

    let offers = [
        Offer(offerImage:"offers", offerTitle: "Sample Title 1", offerDescription: "Description...", offerExpirationDate: "12/12/2022"),
        Offer(offerImage:"offers", offerTitle: "Sample Title 2", offerDescription: "Description...", offerExpirationDate: "12/12/2022"),
        Offer(offerImage:"offers", offerTitle: "Sample Title 3", offerDescription: "Description...", offerExpirationDate: "12/12/2022"),
        Offer(offerImage:"offers", offerTitle: "Sample Title 4", offerDescription: "Description...", offerExpirationDate: "12/12/2022")
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
                OfferCardView()
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

struct SampleCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        SampleCarouselView()
            .previewLayout(.sizeThatFits)
    }
}

