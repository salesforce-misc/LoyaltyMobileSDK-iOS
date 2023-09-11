//
//  ReceiptTableTitleRow.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ReceiptTableTitleRow: View {
	var body: some View {
		HStack {
			Text("Item")
				.productNameFrame()
			Spacer()
				.productQuantitySpaceFrame()
			Text("Quantity")
				.quantityFrame()
			Spacer()
			Text("Unit Price")
				.priceFrame()
			Spacer()
			Text("Total")
				.totalPriceFrame()
		}
		.padding(.horizontal)
	}
}

struct ReceiptTableTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptTableTitleRow()
    }
}
