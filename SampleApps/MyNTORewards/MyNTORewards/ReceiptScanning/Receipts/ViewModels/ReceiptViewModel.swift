//
//  ReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI
import LoyaltyMobileSDK

class ReceiptViewModel: ObservableObject {
	
	final func getColor(for status: String) -> Color {
		switch status {
		case "Rejected":
			return Color.theme.receiptStatusRejected
		case "Pending", "Manual Review", "Draft":
			return Color.theme.receiptStatusPending
		default:
			return .orange
		}
	}
}
