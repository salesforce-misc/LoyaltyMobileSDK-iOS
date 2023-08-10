//
//  ReceiptTableContentRow.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ReceiptTableContentRow: View {
	var itemName: String
	var qty: Int
	var price: Double
	var total: Double
	var body: some View {
		HStack {
			Text("\(itemName)")
			Spacer()
			Text("\(qty)")
			Spacer()
			Text("$\(String(format: "%.0f", price))")
			Spacer()
			Text("$\(String(format: "%.0f", total))")
		}
		.padding(.horizontal)
	}
}

struct ReceiptTableContentRow_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptTableContentRow(itemName: "Converse shoes", qty: 1, price: 599, total: 599)
    }
}
