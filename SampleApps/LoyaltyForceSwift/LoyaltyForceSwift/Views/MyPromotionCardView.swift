//
//  MyOffersCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI

struct MyPromotionCardView: View {
    
    let promotion: PromotionResult
    
    @State var loadImage: Bool = false
    @State var showPromotionDetailView = false

    var body: some View {
        HStack {
            if loadImage {
                Image(promotion.imageName ?? "img-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            } else {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                    .overlay(){
                        ProgressView()
                    }
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(promotion.promotionName)
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    //Image("ic-heart")
                }
                .padding(.top, 10)
                Text(promotion.description ?? "")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Spacer()
                    if let expDate = promotion.endDate {
                        Text("Exp \(expDate)")
                            .font(.labelText)
                            .frame(width: 92, height: 19)
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
        .sheet(isPresented: $showPromotionDetailView) {
            MyPromotionDetailView(promotion: promotion)
        }
    }
}

struct MyPromotionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
            MyPromotionCardView(promotion: dev.promotion)
        }
        
    }
}
