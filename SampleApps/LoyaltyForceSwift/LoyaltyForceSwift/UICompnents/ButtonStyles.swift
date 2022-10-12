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
            .frame(width: 343, height: 48)
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
            .frame(width: 343, height: 48)
            .background(Color.theme.darkButton)
            .cornerRadius(24)
            .padding()
    }
}

struct LightShortButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.smallButtonText)
            .foregroundColor(Color.theme.accent)
            .frame(width: 288, height: 45)
            .background(Color.theme.lightButton)
            .cornerRadius(24)
    }
}

struct DarkShortButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonText)
            .foregroundColor(.white)
            .frame(width: 319, height: 48)
            .background(Color.theme.darkButton)
            .cornerRadius(24)
    }
}
