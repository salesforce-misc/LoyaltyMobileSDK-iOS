//
//  AllTransactionsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI

struct AllTransactionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            //Color.theme.background

            ScrollView(showsIndicators: false) {

                LazyVStack(spacing: 15) {
                
                    ForEach(1...100, id: \.self) { _ in
                        TransactionCardView()
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 20)

            }

        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("ic-backarrow")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //
                } label: {
                    Image("ic-search")
                }
            }
        }
    }

}

struct AllTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactionsView()
    }
}
