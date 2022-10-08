//
//  OfferCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import SwiftUI

struct OfferCardView: View {
    var body: some View {
        VStack {
            Image("offers")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 289, height: 154)
                .cornerRadius(5, corners: [.topLeft, .topRight])
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Camping Fun For Entire Family")
                    .font(.offerTitle)
                Text("The ultimate family camping destination is closer than you might think.")
                    .font(.offerText)
                    .lineSpacing(3)
                Text("Expiration: **12/12/2022**")
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

struct OfferCardView_Previews: PreviewProvider {
    static var previews: some View {
        OfferCardView()
            .previewLayout(.sizeThatFits)
    }
}
