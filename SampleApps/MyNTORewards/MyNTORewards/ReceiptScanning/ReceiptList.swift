//
//  ReceiptList.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptList: View {
	@State var isShowingModel: Bool = false
    var body: some View {
		List {
			ForEach(0..<10) { _ in
				ReceiptListItem(receiptNumber: 43456, receiptDate: "13/07/2023", amount: 187000, points: 500, currency: "INR")
					.padding(-3)
					.onTapGesture {
						isShowingModel = true
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.sheet(isPresented: $isShowingModel) {
			HalfSheet {
				ReceiptPopUpView(receiptNumber: "43456", receiptDate: "13/07/2023")
			}
		}

    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList()
    }
}
