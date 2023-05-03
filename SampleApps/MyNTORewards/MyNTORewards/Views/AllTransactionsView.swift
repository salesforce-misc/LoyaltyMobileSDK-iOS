//
//  AllTransactionsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct AllTransactionsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    
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
                
                VStack(spacing: 15) {
                    if transactionVM.recentTransactions.isEmpty {
						EmptyStateView(title: "No recent transactions",
                                       subTitle: "After you complete a transaction, you’ll see it here for the next 30 days.")
                    }
                    ForEach(Array(transactionVM.recentTransactions.enumerated()), id: \.offset) { index, transaction in
                        TransactionCardView(accessibilityID: "transaction_\(index)", transaction: transaction)
                    }
                }
                HStack {
                    Text("One month ago")
                        .font(.transactionPeriod)
                        .foregroundColor(Color.theme.lightBlackText)
                    Spacer()
                }
                .padding()
                LazyVStack(spacing: 15) {
                    if transactionVM.olderTransactions.isEmpty {
                        EmptyStateView(title: "Nothing to report",
                                       subTitle: "When you complete your first transaction, you’ll find it here.")
                    }
                    ForEach(Array(transactionVM.olderTransactions.enumerated()), id: \.offset) { index, transaction in
                        TransactionCardView(accessibilityID: "transaction_\(index)", transaction: transaction)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .task {
                do {
                    try await transactionVM.loadAllTransactions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    Logger.error("Load All Transactions Error: \(error)")
                }
            }
            .refreshable {
                do {
                    try await transactionVM.reloadAllTransactions(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    Logger.error("Reload All Transactions Error: \(error)")
                }
            }
            
        }
        .loytaltyNavigationTitle("My Transactions")
    }

}

struct AllTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactionsView()
    }
}
