//
//  ErrorView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/7/23.
//

import SwiftUI

struct ProcessingErrorView: View {
    let message1: String
    let message2: String
    
    var body: some View {
        VStack {
            Image("img-astronaut")
            VStack(alignment: .center, spacing: 6) {
                ErrorTextView(message: message1)
                    .padding(.horizontal, 60) // Increase padding to make it shorter
                    
                ErrorTextView(message: message2)
                    .padding(.horizontal, 30) // Decrease padding to make it longer
            }
        }
        
    }
}

struct ErrorTextView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.errorMessageText)
            .foregroundColor(Color(hex: "747474"))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingErrorView(message1: "Oops! Something went wrong", message2: "while processing the request. Try again.")
    }
}
