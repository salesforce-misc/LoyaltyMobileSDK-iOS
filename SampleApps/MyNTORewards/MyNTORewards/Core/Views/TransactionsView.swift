//
//  TransactionsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct TransactionsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    
    var body: some View {
        
        ViewAllView(title: "My Transactions") {
            AllTransactionsView()
        } content: {
            VStack(spacing: 15) {
                if transactionVM.transactions.isEmpty {
                    EmptyStateView(title: "Nothing to report", subTitle: "When you complete your first transaction, you’ll find it here.")
                }
                ForEach(Array(transactionVM.transactions.enumerated()), id: \.offset) { index, transaction in
                    TransactionCardView(accessibilityID: "transaction_\(index)", transaction: transaction)
                }
            }
        }
        .frame(height: 340)
        .task {
            do {
                try await transactionVM.loadTransactions(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error("Load Transactions Error: \(error)")
            }
        }   
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.transactionVM)
    }
}
