//
//  GameZoneActiveView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 13/10/23.
//

import SwiftUI

struct GameZoneActiveView: View {
    var gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 165)), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach((0...6), id: \.self) {
                    if $0 % 3 != 0 {
                        ScrathCardCardView()
                    } else {
                        FortuneWheelCardView()
                    }
                }
            }.padding([.vertical], 24)
        }
    }
}

struct GameZoneActiveView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneActiveView()
    }
}
