//
//  ProfileHeaderView.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/8/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    // TODO: replace this with the image got from member profile
                    Color(hex: "E4E6E9")
                        .frame(width: 40, height: 40)
                    Image("img-profile")
                }
                .clipShape(Circle())
                Spacer()
            }
            
            Text("Julia Green")
                .font(.system(size: 18))
                .fontWeight(.bold)
        }
        
        
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
