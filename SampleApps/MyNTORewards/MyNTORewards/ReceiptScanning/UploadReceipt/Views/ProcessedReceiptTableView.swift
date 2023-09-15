//
//  ProcessedReceiptTableView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 15/09/23.
//

import SwiftUI

struct ProcessedReceiptTableView: View {
	let items: [ProcessedReceiptItem]
	var body: some View {
		VStack(spacing: 0) {
			Rectangle()
				.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
				.frame(height: 1)
				.padding()
			
			ReceiptTableTitleRow()
				.font(.receiptItemsTitleFont)
			Rectangle()
				.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
				.frame(height: 1)
				.padding()
			ScrollView {
				ProcessedReceiptList(items: items)
				Rectangle()
					.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
					.frame(height: 1)
					.padding()
			}
			.frame(maxHeight: .infinity)
		}
		.background(.white)
		.cornerRadius(4)
		.padding()
	}
}

struct ProcessedReceiptTableView_Previews: PreviewProvider {
    static var previews: some View {
		ProcessedReceiptTableView(items: [])
    }
}
