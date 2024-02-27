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
        VStack(spacing: 15) {
            Image("img-astronaut")
            VStack(alignment: .center) {
                Text(message)
                    .font(.errorMessageText)
                    .foregroundColor(Color.theme.textInactive)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30)
            }
        }
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingErrorView(message: "Oops! Something went wrong while processing the request. Try again.")
    }
}
