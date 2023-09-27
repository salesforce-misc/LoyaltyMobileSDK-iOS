//
//  LoyaltyNavLink.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct LoyaltyNavLink<Label: View, Destination: View>: View {
    
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(
            destination:
                LoyaltyNavBarContainerView(content: {
                    destination
                })
                .navigationBarHidden(true)
            ,
            label: {
                label
            })
    }
}

struct LoyaltyNavLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoyaltyNavLink {
                Text("Destination")
                    .loytaltyNavigationTitle("Vouchers")
                    .loyaltyNavBarTabBar(TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(0)))
                
            } label: {
                Text("Go to destination")
            }
            
        }
        
    }
}
