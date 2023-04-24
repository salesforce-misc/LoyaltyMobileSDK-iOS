//
//  SharedViewAllView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/18/22.
//

import SwiftUI

struct ViewAllView<Destination: View, Content: View>: View {
    
    let title: String
    let destination: Destination
    let content: Content
    
    init(title: String, @ViewBuilder destination: () -> Destination, @ViewBuilder content: () -> Content) {
        self.title = title
        self.destination = destination()
        self.content = content()
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text(title)
                    .font(.offerTitle)
                    .foregroundColor(.black)
                    .accessibilityIdentifier(title)
                Spacer()
                LoyaltyNavLink(destination: {
                    destination
                }, label: {
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                        .accessibilityIdentifier("View All")
                })
            }
            .padding()
            
            content
            Spacer()
        }
    }
}

struct ViewAllView_Previews: PreviewProvider {
    static var previews: some View {
        ViewAllView(title: "My Vouchers") {
            AllVouchersView()
        } content: {
            Text("All Vouchers")
        }

    }
}
