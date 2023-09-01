//
//  ReceiptTableContentRow.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ReceiptTableContentRow: View {
	var itemName: String
	var qty: String
	var price: String
	var total: String
	var body: some View {
		HStack {
			Text("\(itemName)")
			Spacer()
			Text("\(qty)")
			Spacer()
			Text("\(price)")
			Spacer()
			Text("\(total)")
		}
		.padding(.horizontal)
	}
}

struct ReceiptTableContentRow_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptTableContentRow(itemName: "Converse shoes", qty: "1", price: "$199", total: "$199")
    }
}
