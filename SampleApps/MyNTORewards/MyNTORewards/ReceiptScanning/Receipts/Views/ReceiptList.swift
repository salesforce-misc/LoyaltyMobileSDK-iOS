//
//  ReceiptList.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptList: View {
    @EnvironmentObject var receiptListVM: ReceiptListViewModel
    
    var body: some View {
		List {
			ForEach(receiptListVM.filteredReceipts) { receipt in
				ReceiptListItem(receipt: receipt)
					.padding(-3)
					.background {
						LoyaltyNavLink {
							ReceiptDetailView(receipt: receipt)
								.environmentObject(receiptListVM)
						} label: {
							EmptyView()
						}
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList()
    }
}
