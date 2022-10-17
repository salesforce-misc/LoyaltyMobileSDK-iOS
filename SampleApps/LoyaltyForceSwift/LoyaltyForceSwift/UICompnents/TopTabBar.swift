//
//  TopTabBar.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI

struct TopTabBar: View, Equatable {

    let barItems: [String]
    @Binding var tabIndex: Int
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(0..<barItems.count, id: \.self) { index in
                TabBarButton(text: barItems[index], isSelected: .constant(tabIndex == index))
                    .onTapGesture {
                        withAnimation {
                            tabIndex = index
                        }
                    }
            }
            Spacer()
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .padding(.leading)
        .background(Color.white)
    }
    
    static func == (lhs: TopTabBar, rhs: TopTabBar) -> Bool {
        return lhs.barItems == rhs.barItems
    }
}

struct TopTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(0))

    }
}

struct TabBarButton: View {
    
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(isSelected ? .offersTabSelected : .offersTabUnselected)
            .foregroundColor(isSelected ? Color.theme.accent : Color.theme.textInactive)
            .frame(width: 20 + text.stringWidth(), height: 4)
            .overlay(
                Capsule()
                    .fill(Color.theme.accent)
                    .frame(width: 20 + text.stringWidth(), height: 4)
                    .offset(y: 20)
                    .opacity(isSelected ? 1 : 0)
            )
    }
}
