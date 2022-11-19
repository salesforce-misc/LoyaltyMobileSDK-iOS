//
//  TransactionsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct TransactionsView: View {
    var body: some View {
        
        ViewAllView(title: "My Transactions") {
            AllTransactionsView()
        } content: {
            VStack(spacing: 15) {
                TransactionCardView()
                TransactionCardView2()
                TransactionCardView3()
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
