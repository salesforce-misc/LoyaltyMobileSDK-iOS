//
//  MyOffersCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI

struct MyOffersCardView: View {
    var body: some View {
        HStack {
            Image("offer2")
                .resizable()
                .scaledToFill()
                .frame(width: 133, height: 166)
                .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text("Shop and get free product samples")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("Get free sample on orders above $5000")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("Free")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 03/08/22")
                        .font(.labelText)
                        .frame(width: 92, height: 19)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .padding(.bottom, 10)
            }
            .padding(.all, 6)
            Spacer()
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
    }
}

struct MyOffersCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
            MyOffersCardView()
        }
        
    }
}
