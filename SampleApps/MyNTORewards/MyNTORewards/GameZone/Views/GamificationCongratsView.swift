//
//  GamificationCongratsView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 10/10/23.
//

import SwiftUI

struct GamificationCongratsView: View {
    let imageSize = CGSize(width: 168, height: 167)
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image("img-congrats")
                        .resizable()
                        .scaledToFit()
                    Image("img-gifts-color-art")
                        .frame(width: imageSize.width, height: imageSize.height)
                        .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                        .padding(.bottom, 29)
                        .padding(.top, -imageSize.height/2)
                    VStack(spacing: 5) {
                        Text("Congratulations!!")
                            .font(.congratsTitle)
                            .foregroundColor(Color.theme.lightText)
                        Text("You have won A voucher for 20% off for your nextpurchase.Go to the voucher section to claim your reward!")
                            .font(.congratsText)
                            .foregroundColor(Color.theme.superLightText)
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }.diableBounceForScrollView()
            Button("Back") {
            }
            .buttonStyle(DarkFlexibleButton())
            .padding(.bottom, 50)
        }.edgesIgnoringSafeArea(.top)
        
    }
}
struct ScrollBounceModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .scrollBounceBehavior(.basedOnSize)
        } else {
            content
        }
    }
}

extension View {
    func diableBounceForScrollView() -> some View {
        modifier(ScrollBounceModifier())
    }
}

struct GamificationCongratsView_Previews: PreviewProvider {
    static var previews: some View {
        GamificationCongratsView()
    }
}
