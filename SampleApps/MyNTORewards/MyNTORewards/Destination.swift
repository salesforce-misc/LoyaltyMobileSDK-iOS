//
//  RouterDestination.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

enum SheetDestination: Identifiable {
	var id: UUID {
		UUID()
	}
	
	case processingReceipt(receiptListViewModel: ReceiptListViewModel)
}

enum RouterDestination: Identifiable, Hashable {
	var id: UUID {
		UUID()
	}
	
	case receipts
    case gameZone
    case gameZoneBetterLuck
    case gameZoneCongrats(offerText: String, rewardType: String)
    case vouchers
    case referrals
}
