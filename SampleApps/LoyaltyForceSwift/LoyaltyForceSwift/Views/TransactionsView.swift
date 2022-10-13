//
//  TransactionsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct TransactionsView: View {
    var body: some View {
    
        VStack {
            HStack {
                Text("Transations")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                LoyaltyNavLink(destination: {
                    AllTransactionsView()
                }, label: {
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                })
                
            }
            .padding()
            
            VStack(spacing: 15) {
                TransactionCardView()
                TransactionCardView()
                TransactionCardView()
            }
            
        }
        .frame(height: 320)
        
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
