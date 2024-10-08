//
//  GameNoLuckView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 10/10/23.
//

import SwiftUI
struct GamificationNoLuckView: View {
    @Environment(\.dismiss) var dismiss
    let imageSize = CGSize(width: 165, height: 165)

    var body: some View {
        VStack {
            // Scrollview  is for Dynamic font support
            ScrollView {
                VStack {
                    ZStack(alignment: .center) {
                        Rectangle().fill(Color.theme.noLuckViewLineColor).frame(width: 282, height: 1).rotationEffect(Angle(degrees: 32.0))
                        Image("img-game-raffle")
                            .frame(width: imageSize.width, height: imageSize.height)
                            .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                            .clipped()
                    }.padding(.top, 77)
                    VStack(spacing: 5) {
                        Text(StringConstants.Gamification.failureMessageTitle)
                            .font(.betterLuckText)
                            .foregroundColor(Color.theme.lightText)
                        Group {
                            Text(StringConstants.Gamification.failureBodyText)
                            Text(StringConstants.Gamification.failureBodySubText)
                                .padding(.top, 29)
                        }
                        .font(.congratsText)
                        .foregroundColor(Color.theme.superLightText)
                        .lineSpacing(5)
                    }.padding(.top, 45)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }.diableBounceForScrollView()
            Button(StringConstants.Gamification.backButtonTitle) {
                dismiss()
            }
            .buttonStyle(DarkFlexibleButton(buttonFont: .boldButtonText))
            .padding([.bottom], 50)
        }
        
    }
}

#Preview {
	GamificationNoLuckView()
}
