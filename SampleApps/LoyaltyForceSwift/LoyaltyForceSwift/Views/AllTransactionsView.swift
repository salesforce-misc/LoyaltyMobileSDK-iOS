//
//  AllTransactionsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI

struct AllTransactionsView: View {
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {
                
                HStack {
                    Text("Recent")
                        .font(.transactionPeriod)
                        .foregroundColor(Color.theme.lightBlackText)
                    Spacer()
                }
                .padding()
                
                VStack {
                    TransactionCardView()
                    TransactionCardView()
                    TransactionCardView()
                }
                HStack {
                    Text("One month ago")
                        .font(.transactionPeriod)
                        .foregroundColor(Color.theme.lightBlackText)
                    Spacer()
                }
                .padding()
                LazyVStack(spacing: 15) {
                    
                    ForEach(1...100, id: \.self) { _ in
                        TransactionCardView()
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            
        }
        .loytaltyNavigationTitle("Transactions")
    }

}

struct AllTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactionsView()
    }
}
