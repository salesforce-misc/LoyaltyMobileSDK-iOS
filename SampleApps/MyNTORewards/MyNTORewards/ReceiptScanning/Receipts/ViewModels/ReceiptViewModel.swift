//
//  ReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI

class ReceiptViewModel: ObservableObject {
	@Published var receiptState: ReceiptState = .processing
	
	final func getColor(for status: String) -> Color {
		switch status {
		case "Rejected":
			return Color.theme.receiptStatusRejected
		case "Pending", "Submitted for Manual Review":
			return Color.theme.receiptStatusPending
		default:
			return .orange
		}
	}
}
