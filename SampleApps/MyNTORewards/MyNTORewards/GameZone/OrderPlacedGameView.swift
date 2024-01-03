//
//  OrderPlacedGameView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/23.
//

import SwiftUI
import LoyaltyMobileSDK
import GamificationMobileSDK_iOS

struct OrderPlacedGameView: View {
	@EnvironmentObject private var promotionVM: PromotionViewModel
	@EnvironmentObject private var orderDetailsVM: OrderDetailsViewModel
	@EnvironmentObject private var appViewRouter: AppViewRouter
	@EnvironmentObject private var routerPath: RouterPath
	@EnvironmentObject private var gameZoneViewModel: GameZoneViewModel
	
	@State private var orderNumber = ""
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
                
                Text("Your Order \(orderNumber) is Placed.")
                    .font(.orderPlacedTitle)
					.multilineTextAlignment(.center)
                Text("You can view the delivery status on the tracking page.")
                    .font(.orderPlacedDescription)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 85)
                
                if game == .spinaWheel {
                    Text("Congratulations! You’ve unlocked a reward. Give it a spin!")
                        .font(.unlockedGameTitle)
                        .padding(.top, 40)
                        
                    Image("img-wheel")
					
					NavigationLink {
						FortuneWheelView(gameDefinitionModel: orderDetailsVM.gameDefinition)
							.navigationBarBackButtonHidden()
					} label: {
						Text("Play")
							.longFlexibleButtonStyle()
					}
					.padding(.top, 30)
                        
                    Button {
                        // Navigate to GameZoneView()
						promotionVM.isCheckoutNavigationActive = false
                    } label: {
                        Text("Play later in the Game Zone")
                            .font(.footerButtonText)
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color.theme.accent)
                } else if game == .scratchCard {
                    Text("Congratulations! You’ve unlocked a scratch card.")
                        .font(.unlockedGameTitle)
                        .padding(.top, 40)
                        
                    Image("img-card")
                    
					NavigationLink {
						ScratchCardView(gameDefinitionModel: orderDetailsVM.gameDefinition, backToRoot: {
							routerPath.startWithGameZoneInMore = true
							appViewRouter.selectedTab = Tab.more.rawValue
							promotionVM.isCheckoutNavigationActive = false
						})
							.navigationBarBackButtonHidden()
					} label: {
						Text("Play")
							.longFlexibleButtonStyle()
					}
					.padding(.top, 30)
                        
                    Button {
						promotionVM.isCheckoutNavigationActive = false
                    } label: {
                        Text("Play later in the Game Zone")
                            .font(.footerButtonText)
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color.theme.accent)
                }
                
            }
            Spacer()
        }
		.task {
			do {
				let orderDetails = try await orderDetailsVM.getOrderDetails()
				orderNumber = orderDetails.orderNumber
			} catch {
				Logger.error("Error fetching order details..")
			}
		}
    }
}

#Preview {
    OrderPlacedGameView(game: .spinaWheel)
        .environmentObject(OrderDetailsViewModel())
}

#Preview {
    OrderPlacedGameView(game: .scratchCard)
        .environmentObject(OrderDetailsViewModel())
}
