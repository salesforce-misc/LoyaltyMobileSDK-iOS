//
//  ProfileView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
       
        NavigationView {
            ZStack {
                Color.theme.background
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 400)
                            .foregroundColor(Color.white)
                            .padding(.top, -356)
                        VStack(spacing: 10) {
                            
                            ProfileHeaderView()
                            TransactionsView()
                            VouchersView()
                            BenefitView()
                            BadgesView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 50)
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
                
            }
            .navigationBarHidden(true)
        }
        
        
        
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

// Add this for custom navigationLink
extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
