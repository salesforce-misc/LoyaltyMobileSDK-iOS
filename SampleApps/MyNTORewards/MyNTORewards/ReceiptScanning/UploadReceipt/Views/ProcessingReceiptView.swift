//
//  ProcessingReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 03/08/23.
//

import SwiftUI

struct ProcessingReceiptView: View {
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@EnvironmentObject var routerPath: RouterPath
    var body: some View {
		Group {
			switch processedReceiptViewModel.receiptState {
			case .processing:
				ProcessingView()
			case .processed:
				ProcessedReceiptView()
			case .submitted(let points):
				ReceiptCongratsView(points: points)
			}
		}
		.environmentObject(processedReceiptViewModel)
    }
}

struct ProcessingView: View {
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	
	var body: some View {
        ReceiptScanningProgressView(numberOfSteps: 2, 
                                    currentStep: processedReceiptViewModel.currentStep,
                                    title: processedReceiptViewModel.processedStepTitle,
                                    subtitle: "Hang in there! This may take a minute.")
	}
}

struct ProcessingReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingReceiptView()
    }
}
