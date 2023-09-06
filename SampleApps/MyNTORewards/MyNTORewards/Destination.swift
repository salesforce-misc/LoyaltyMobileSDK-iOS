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
	
	case processingReceipt
}
