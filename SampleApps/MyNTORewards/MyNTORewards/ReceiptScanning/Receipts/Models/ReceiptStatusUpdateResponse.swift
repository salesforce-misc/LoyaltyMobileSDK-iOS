//
//  ReceiptStatusUpdateResponse.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 12/09/23.
//

import Foundation

struct ReceiptStatusUpdateResponse: Decodable {
	let status: String
	let message: String
	let errorCode: String
}
