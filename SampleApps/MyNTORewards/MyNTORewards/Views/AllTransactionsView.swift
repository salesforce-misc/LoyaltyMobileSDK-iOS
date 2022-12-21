//
//  AllTransactionsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI

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
                        EmptyStateView(title: "You have no Recent Transactions")
                    }
                    ForEach(transactionVM.recentTransactions) { transaction in
                        TransactionCardView(transaction: transaction)
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
                        EmptyStateView(title: "You have no Earlier Transactions")
                    }
                    ForEach(transactionVM.olderTransactions) { transaction in
                        TransactionCardView(transaction: transaction)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .task {
                do {
                    try await transactionVM.loadAllTransactions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
                } catch {
                    print("Load All Transactions Error: \(error)")
                }
            }
            .refreshable {
                do {
                    try await transactionVM.reloadAllTransactions(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
                } catch {
                    print("Reload All Transactions Error: \(error)")
                }
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
