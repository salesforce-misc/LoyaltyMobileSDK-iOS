//
//  ReceiptList.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptList: View {
	@EnvironmentObject var routerPath: RouterPath
    @EnvironmentObject var receiptListVM: ReceiptListViewModel
    
    var body: some View {
		List {
            ForEach(receiptListVM.receipts) { receipt in
				ReceiptListItem(receipt: receipt)
				.padding(-3)
				.background {
					LoyaltyNavLink {
						ReceiptDetailView(receipt: receipt)
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
