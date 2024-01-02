//
//  PlayedGameNoLuckView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 22/12/23.
//

import SwiftUI

struct PlayedGameNoLuckView: View {
    @Environment(\.dismiss) var dismiss
    let imageSize = CGSize(width: 165, height: 165)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 12)
            // Scrollview  is for Dynamic font support
            ScrollView {
                VStack {
                    ZStack(alignment: .center) {
                        Image("img-noLuck")
                            .frame(width: imageSize.width, height: imageSize.height)
                            .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                    }.padding(.top, 77)
                    VStack(spacing: 5) {
                        Text(StringConstants.Gamification.failureMessageTitle)
                            .font(.betterLuckText)
                            .foregroundColor(Color.theme.lightText)
                        Group {
                            Text("You did not win anything in this game.")
                                .padding(.top, 10)
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
    PlayedGameNoLuckView()
}
