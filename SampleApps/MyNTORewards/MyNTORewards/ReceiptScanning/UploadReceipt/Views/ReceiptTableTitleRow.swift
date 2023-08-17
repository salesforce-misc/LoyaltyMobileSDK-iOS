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
			Spacer()
			Text("Quantity")
			Spacer()
			Text("Unit Price")
			Spacer()
			Text("Total")
		}
		.padding(.horizontal)
	}
}

struct ReceiptTableTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptTableTitleRow()
    }
}
