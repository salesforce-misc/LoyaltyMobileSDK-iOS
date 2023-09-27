//
//  LoyaltyConditionalNavLink.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/04/23.
//

import SwiftUI

struct LoyaltyConditionalNavLink<Label: View, Destination: View>: View {
	
	let destination: Destination
	let label: Label
	@Binding var isActive: Bool
	
	init(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
		self.destination = destination()
		self.label = label()
		self._isActive = isActive
	}
	
	var body: some View {
        label
            .navigationDestination(isPresented: $isActive) {
                LoyaltyNavBarContainerView(content: {
                    destination
                })
                .navigationBarHidden(true)
            }
	}
}

struct LoyaltyConditionalNavLink_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
            LoyaltyConditionalNavLink(isActive: .constant(true)) {
				Text("Destination")
					.loytaltyNavigationTitle("Vouchers")
					.loyaltyNavBarTabBar(TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(0)))
				
			} label: {
				Text("Go to destination")
			}
			
		}
		
	}
}
