//
//  GameCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/19/23.
//

import SwiftUI

struct FortuneWheelCardView: View {
    
    @State var showFortuneWheel = false
    
    var body: some View {
        
        VStack {
            Image("img-fortune-wheel")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 165, height: 90)
                .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Bonnie and Clyde Style Promotion")
                        .font(.gameTitle)
                        .foregroundColor(Color(hex: "#181818"))
                    Spacer()
                }
                Spacer()
                Text("Spin a Wheel")
                    .font(.redeemText)
                    .foregroundColor(Color(hex: "#444444"))
                Text("Expiring today")
                    .font(.labelText)
                    .frame(width: 92, height: 19)
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
            showFortuneWheel.toggle()
        }
        .fullScreenCover(isPresented: $showFortuneWheel) {
            FortuneWheelView()
        }
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        FortuneWheelCardView()
    }
}
