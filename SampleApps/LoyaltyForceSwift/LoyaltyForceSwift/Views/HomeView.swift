//
//  HomeView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    var body: some View {
        ZStack {
            Color.theme.background
            //Color.black
            ScrollView(showsIndicators: false) {
                Rectangle()
                    .frame(height: 400)
                    .foregroundColor(Color.theme.accent)
                    .padding(.top, -360)
                HStack {
                    Text("Welcome, Julia Green!")
                        .padding(.leading, 15)
                    Spacer()
                    Text("17850 Points")
                        .padding(.trailing, 15)
                }
                .frame(height: 58)
                .frame(maxWidth: .infinity)
                .background(Color.theme.backgroundPink)
                .background(Color.black)
                .padding(.top, -10)
                
                
                // Offers & Promotions
                Rectangle()
                    .frame(width: 400, height: 400)
                    .foregroundColor(.pink)
                    .padding(.top, 50)
                    .overlay(
                        Text("Offers & Promotions")
                    )
                
                // Redeem Points
                Rectangle()
                    .frame(width: 400, height: 400)
                    .foregroundColor(.blue)
                    .overlay(
                        Text("Redeem Points")
                    )
            }
            
            
            VStack{
                VStack(spacing: 0) {
                    HStack {
                        Image("ic-logo-home")
                            .padding(.leading, 15)
                        Spacer()
                        Image("ic-magnifier")
                            .padding(.trailing, 15)
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.accent)
                }
                Spacer()
            }
                
                
                

            
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

