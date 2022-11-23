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
                    Text("Free")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 03/08/23")
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

/*
struct MyOffersCardView1: View {
    @State var loadImage: Bool = false

    var body: some View {
        HStack {
            if loadImage {
                Image("shoes1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            }else{
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
                    Text("Discount on your next shoes purchase")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("Get $50 off voucher with $1000 purchase")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("$50 off")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 12/21/22")
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
    }
}

struct MyOffersCardView2: View {
    @State var loadImage: Bool = false

    var body: some View {
        HStack {
            if loadImage {
                Image("jean1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            }else{
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
                    Text("20% off on demin jeans")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("No minimum purchase required")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("20% off")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 09/08/22")
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
    }
}

struct MyOffersCardView3: View {
    @State var loadImage: Bool = false

    var body: some View {
        HStack {
            if loadImage {
                Image("cosmetics1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            }else{
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
                    Text("Shop and get free product samples")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("Get free sample on orders above $500")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("Free")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 12/12/2022")
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
    }
}

struct MyOffersCardView4: View {
    @State var loadImage: Bool = false

    var body: some View {
        HStack {
            if loadImage {
                Image("meal1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            }else{
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
                    Text("Dinner at a French Restaurant")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("Enjoy a eat out at an award winning restaurant")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("$100 off")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 12/31/2022")
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
    }
}

struct MyOffersCardView5: View {
    @State var loadImage: Bool = false

    var body: some View {
        HStack {
            if loadImage {
                Image("coffee1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 166)
                    .cornerRadius(5, corners: [.topLeft, .bottomLeft])
            }else{
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
                    Text("Shop and get free product samples")
                        .font(.redeemTitle)
                        .lineSpacing(5)
                    Spacer()
                    Image("ic-heart")
                }
                .padding(.top, 10)
                Text("Get free coffee on orders above $200")
                    .font(.redeemText)
                    .foregroundColor(.theme.textInactive)
                    .lineSpacing(5)
                Spacer()
                HStack {
                    Text("Free")
                        .font(.regularText)
                    Spacer()
                    Text("Exp 01/31/2023")
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
    }
}
*/

struct MyPromotionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
            MyPromotionCardView(promotion: dev.promotion)
        }
        
    }
}
