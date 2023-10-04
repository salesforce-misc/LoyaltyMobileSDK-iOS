//
//  ScrathCardCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/3/23.
//

import SwiftUI

struct ScrathCardCardView: View {
    @State var showScratchCard = false
    
    var body: some View {
        
        VStack {
            ZStack {
                Color(hex: "#E5E5E5")
                Image("img-scratch-card")
            }
            .frame(width: 165, height: 90)
            .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Cat Scratch Fever")
                        .font(.gameTitle)
                        .foregroundColor(Color(hex: "#181818"))
                    Spacer()
                }
                Spacer()
                Text("Scratch Card")
                    .font(.redeemText)
                    .foregroundColor(Color(hex: "#444444"))
                Text("Expiring tomorrow")
                    .font(.labelText)
                    .frame(width: 111, height: 19)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .padding(.all, 6)
            Spacer()
        }
        .frame(width: 165, height: 203)
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
            showScratchCard.toggle()
        }
        .fullScreenCover(isPresented: $showScratchCard) {
            ScratchCardView()
        }
    }
}

#Preview {
    ScrathCardCardView()
}
