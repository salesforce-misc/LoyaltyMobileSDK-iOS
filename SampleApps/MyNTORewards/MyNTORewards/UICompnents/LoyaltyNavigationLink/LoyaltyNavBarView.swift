//
//  LoyaltyNavBarView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct LoyaltyNavBarView: View {
    
    @Environment(\.dismiss) private var dismiss
    let showSearchButton: Bool
    let title: String
	let subtitle: String
    let tabBar: TopTabBar?
    
    var body: some View {
        VStack {
            HStack {
                backButton
                Spacer()
                if showSearchButton {
                    searchButton
                }
            }
            .padding()
            if let tabBar = tabBar {
                titleSection
                tabBar
            } else {
                titleSection
                    .padding(.bottom)
            }
        }
        .background(Color.white.ignoresSafeArea(edges: .top))
    }
}

struct LoyaltyNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyNavBarView(showSearchButton: true,
                          title: "Vouchers",
						  subtitle: "",
                          tabBar: TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(0)))
    }
}

extension LoyaltyNavBarView {
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image("ic-backarrow")
        })
    }
    
    private var searchButton: some View {
        Button(action: {
            // to be implemented
        }, label: {
            Image("ic-search")
        })
    }
    
    private var titleSection: some View {
		VStack(spacing: 8) {
			HStack {
				Text(title)
					.font(.nameText)
				Spacer()
			}
			.padding(.horizontal)
			if !subtitle.isEmpty {
				HStack {
					Text(subtitle)
						.font(.loyaltyNavBarSubtitleText)
					Spacer()
				}
				.padding(.horizontal)
				.padding(.bottom, 8)
			}
		}
    }
    
}
