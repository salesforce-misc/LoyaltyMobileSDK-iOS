//
//  ErrorView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/7/23.
//

import SwiftUI

struct ProcessingErrorView: View {
    var body: some View {
        VStack {
            Image("img-astronaut")
            VStack(alignment: .center, spacing: 6) {
                Text(StringConstants.Receipts.processingErrorMessageLine1)
                    .font(.errorMessageText)
                    .foregroundColor(Color(hex: "747474"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 60) // Increase padding to make it shorter
                    
                Text(StringConstants.Receipts.processingErrorMessageLine2)
                    .font(.errorMessageText)
                    .foregroundColor(Color(hex: "747474"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30) // Decrease padding to make it longer
            }
        }
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingErrorView()
    }
}
