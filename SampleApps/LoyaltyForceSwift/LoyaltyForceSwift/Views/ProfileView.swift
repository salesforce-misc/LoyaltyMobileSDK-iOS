//
//  ProfileView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct ProfileView: View {
    
    @State var showAllVouchersView = false
    
    var body: some View {
        
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 400)
                        .foregroundColor(Color.white)
                        .padding(.top, -356)
                    VStack(spacing: 15) {
                        
                        ProfileHeaderView()
                        TransactionsView()
                        VouchersView(showAllVouchersView: $showAllVouchersView)
                        BenefitView()
                        BadgesView()
                    }
                    .frame(maxWidth: .infinity)
                }
                

            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Profile")
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                Spacer()
            }
            
            if showAllVouchersView {
                AllVouchersView(showAllVouchersView: $showAllVouchersView)
                    .transition(.move(edge: .trailing))
            }
            
        }
        
        
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
