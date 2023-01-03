//
//  TopTabBar.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI

struct TopTabBar: View, Equatable {

    let barItems: [String]
    @Binding var tabIndex: Int
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(0..<barItems.count, id: \.self) { index in
                let lableText = barItems[index]
                ZStack(alignment: .bottom){
                    if(tabIndex == index) {
                        Capsule()
                            .fill(Color.theme.accent)
                            .matchedGeometryEffect(id: "offer_underscore", in: namespace, properties: .frame)
                            .frame(width: 20 + lableText.stringWidth(), height: 4)
                            .offset(y: 20)
                    }
                    Text(lableText)
                        .font(.offersTabSelected)
                        .foregroundColor(tabIndex == index ? Color.theme.accent : Color.theme.textInactive)
                        .frame(width: 20 + lableText.stringWidth(), height: 4)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
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
