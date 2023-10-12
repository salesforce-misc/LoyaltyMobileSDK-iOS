//
//  OrderPlacedGameView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/23.
//

import SwiftUI

struct OrderPlacedGameView: View {
    
    let game: GameType
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 15) {
                HStack {
                    Image("ic-logo-home")
                        .padding(.leading, 15)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.theme.accent)
                
                Image("img-checked")
                    .padding(.top, 15)
                
                Text("Order Placed!")
                    .font(.orderPlacedTitle)
                Text("Your payment is complete, please check the deliver details at the tracking page.")
                    .font(.orderPlacedDescription)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 85)
                
                if game == .spinAWheel {
                    Text("Spin a Wheel Game Unlocked!")
                        .font(.unlockedGameTitle)
                        .padding(.top, 40)
                    Text("This is your 10th order of this month and has unlocked a one time chance to win instant rewards.")
                        .font(.unlockedGameDescription)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        
                    Image("img-wheel")
                    
                    Button {
                        // Navigate to FortuneWheelView()
                    } label: {
                        Text("Play Now")
                            .frame(maxWidth: .infinity)
                    }
                    .longFlexibleButtonStyle()
                    .padding(.top, 30)
                        
                    Button {
                        // Navigate to GameZoneView()
                    } label: {
                        Text("Play Later in the Game Zone")
                            .font(.footerButtonText)
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color.theme.accent)
                } else if game == .scratchCard {
                    Text("Scratch and Win Game Unlocked!")
                        .font(.unlockedGameTitle)
                        .padding(.top, 40)
                    Text("Your spent of more than $200 this month has unlocked a one time chance to win instant rewards.")
                        .font(.unlockedGameDescription)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        
                    Image("img-card")
                    
                    Button {
                        // Navigate to ScratchCardView()
                    } label: {
                        Text("Play Now")
                            .frame(maxWidth: .infinity)
                    }
                    .longFlexibleButtonStyle()
                    .padding(.top, 30)
                        
                    Button {
                        // Navigate to Continue Shopping
                    } label: {
                        Text("Continue Shopping")
                            .font(.footerButtonText)
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color.theme.accent)
                }
                
            }
            Spacer()
        }
    }
}

enum GameType {
    case spinAWheel
    case scratchCard
}

#Preview {
    OrderPlacedGameView(game: .spinAWheel)
}

#Preview {
    OrderPlacedGameView(game: .scratchCard)
}
