//
//  ReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import Foundation

class ReceiptViewModel: ObservableObject {
	@Published var receiptState: ReceiptState = .processing
}
