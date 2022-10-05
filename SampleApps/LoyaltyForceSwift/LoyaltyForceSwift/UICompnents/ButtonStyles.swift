//
//  LongButton.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/23/22.
//

import SwiftUI

struct LightLongButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonText)
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: 343, maxHeight: 48)
            .background(Color.theme.lightButton)
            .cornerRadius(24)
            .padding()
    }
}

struct DarkLongButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonText)
            .foregroundColor(.white)
            .frame(maxWidth: 343, maxHeight: 48)
            .background(Color.theme.darkButton)
            .cornerRadius(24)
            .padding()
    }
}
