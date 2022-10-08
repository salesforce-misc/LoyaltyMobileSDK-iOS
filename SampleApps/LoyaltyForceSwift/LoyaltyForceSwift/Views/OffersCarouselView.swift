//
//  OffersCarouselView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI
import UIKit

struct OffersCarouselView: View {
    
    @State private var index = 0
    
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
                        // Offers View
                    }
            }
            .padding()
            TabView(selection: $index) {
                ForEach((0..<4), id: \.self) { index in
                    OfferCardView()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.accent)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.theme.backgroundPink)
            }
            .offset(y: -30)
            
        }
        .frame(height: 540)
        .background(Color.white)
    }
}

struct OffersCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        OffersCarouselView()
            .previewLayout(.sizeThatFits)
    }
}
