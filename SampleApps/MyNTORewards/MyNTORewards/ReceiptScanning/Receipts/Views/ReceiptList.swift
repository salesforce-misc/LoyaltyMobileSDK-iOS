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
		ScrollView {
			LazyVGrid(columns: [GridItem(.flexible())]) {
				ForEach(receiptListVM.filteredReceipts) { receipt in
					LoyaltyNavLink {
						ReceiptDetailView(receipt: receipt)
							.environmentObject(receiptListVM)
					} label: {
						ReceiptListItem(receipt: receipt)
							.padding(.horizontal)
							.padding(.vertical, 3)
							.foregroundColor(.black)
					}
				}
			}
		}
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList()
    }
}
