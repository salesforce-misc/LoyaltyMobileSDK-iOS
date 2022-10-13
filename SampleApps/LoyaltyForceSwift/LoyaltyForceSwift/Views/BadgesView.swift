//
//  BadgesView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct BadgesView: View {
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Text("Badges")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                LoyaltyNavLink {
                    AllBadgesView()
                } label: {
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                }
            }
            .padding()
            
            HStack {
                Spacer()
                BadgeCardView(image: "gift", label: "Giver")
                Spacer()
                BadgeCardView(image: "trusted", label: "Icon")
                Spacer()
                BadgeCardView(image: "sheriff", label: "All Star")
                Spacer()
            }
            
        }
        .frame(height: 400)
    }
}

struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        BadgesView()
    }
}
