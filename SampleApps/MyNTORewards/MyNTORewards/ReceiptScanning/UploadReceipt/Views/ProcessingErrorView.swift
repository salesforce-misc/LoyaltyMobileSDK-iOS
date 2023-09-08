//
//  ErrorView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/7/23.
//

import SwiftUI

struct ProcessingErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image("img-astronaut")
            Text(message)
                .font(.errorMessageText)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 45)
                .accessibilityIdentifier(message)
        }
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingErrorView(message: "Oops! Something went wrong while processing the request. Try again.")
    }
}
