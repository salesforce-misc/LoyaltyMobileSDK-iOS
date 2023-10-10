//
//  GameNoLuckView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 10/10/23.
//

import SwiftUI
struct GamificationNoLuckView: View {
    let imageSize = CGSize(width: 165, height: 165)

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image("img-game-raffle")
                        .frame(width: imageSize.width, height: imageSize.height)
                        .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                        .padding(.top, 77)
                        .clipped()

                    VStack(spacing: 5) {
                        Text("Better luck next time!")
                            .font(.betterLuckText)
                            .foregroundColor(Color.theme.lightText)
                        
                        Group {
                            Text("Thank you for playing...")
                            Text("Keep a watch out for more such offers.")
                                .padding(.top, 29)
                        }
                        .font(.congratsText)
                        .foregroundColor(Color.theme.superLightText)
                    }.padding(.top, 45)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }.diableBounceForScrollView()
            Button("Back") {
            }
            .buttonStyle(DarkFlexibleButton())
            .padding([.bottom], 50)
        }
        
    }
}

struct GamificationNoLuckView_Previews: PreviewProvider {
    static var previews: some View {
        GamificationNoLuckView()
    }
}
