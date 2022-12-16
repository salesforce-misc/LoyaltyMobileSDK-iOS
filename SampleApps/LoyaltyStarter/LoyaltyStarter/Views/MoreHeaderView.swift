//
//  ProfileHeaderView.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/8/22.
//

import SwiftUI

struct MoreHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("img-profile")
                Spacer()
            }
            
            Text("Julia Green")
                .font(.nameText)
        }
    }
}

struct MoreHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MoreHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
