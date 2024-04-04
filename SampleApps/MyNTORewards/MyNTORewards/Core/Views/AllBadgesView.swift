//
//  AllBadgesView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct AllBadgesView: View {
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {
                
                VStack {
                    HStack {
                        Spacer()
                        BadgeCardView(image: "gift", label: "Giver")
                        Spacer()
                        BadgeCardView(image: "trusted", label: "Icon")
                        Spacer()
                        BadgeCardView(image: "sheriff", label: "All Star")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        BadgeCardView(image: "gift", label: "Giver")
                        Spacer()
                        BadgeCardView(image: "trusted", label: "Icon")
                        Spacer()
                        BadgeCardView(image: "sheriff", label: "All Star")
                        Spacer()
                    }
                    
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
                .padding()
                
            }
            
        }
        .loytaltyNavigationTitle("Badges")
    }
}

struct AllBadgesView_Previews: PreviewProvider {
    static var previews: some View {
        AllBadgesView()
    }
}
