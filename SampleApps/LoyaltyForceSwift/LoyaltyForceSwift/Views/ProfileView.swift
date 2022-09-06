//
//  ProfileView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
            BenefitView()
        }
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
