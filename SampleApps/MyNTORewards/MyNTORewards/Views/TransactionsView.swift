//
//  TransactionsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct TransactionsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    
    var body: some View {
        
        ViewAllView(title: "My Transactions") {
            AllTransactionsView()
        } content: {
            VStack(spacing: 15) {
                if transactionVM.transactions.isEmpty {
                    EmptyStateView(title: "You have no Transactions")
                }
                ForEach(transactionVM.transactions) { transaction in
                    TransactionCardView(transaction: transaction)
                }
            }
        }
        .frame(height: 320)
        .task {
            do {
                try await transactionVM.loadTransactions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Load Transactions Error: \(error)")
            }
        }   
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
