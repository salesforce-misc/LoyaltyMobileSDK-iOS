//
//  BadgeCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct BadgeCardView: View {
    
    let image: String
    let label: String
    
    var body: some View {
        
        VStack {
            Spacer()
            Image(image)
            Spacer()
            Text(label)
                .font(.badgeLabel)
                .frame(width: 106, height: 35)
                .background(Color.theme.badgeBackground)
        }
        .frame(width: 106, height: 126)
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
    }
}

struct BadgeCardView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeCardView(image: "gift", label: "Giver")
    }
}
