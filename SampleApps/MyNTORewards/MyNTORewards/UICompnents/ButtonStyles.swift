//
//  LongButton.swift
//  MyNTORewards
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

struct DarkShortPromotionButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.boldButtonText)
            .foregroundColor(.white)
            .frame(width: 152, height: 48)
            .background(Color.theme.darkButton)
            .cornerRadius(24)
    }
}

struct LightShortPromotionButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.boldButtonText)
            .foregroundColor(Color.theme.accent)
            .frame(width: 152, height: 48)
            .background(Color.white)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.theme.accent, lineWidth: 1)
            )
    }
}

struct LightShortReferralsButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.boldButtonText)
            .foregroundColor(Color.theme.accent)
            .frame(width: 280, height: 39)
            .background(Color.white)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.theme.accent, lineWidth: 1)
            )
    }
}

struct LightLongPromotionButton: ButtonStyle {
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.boldButtonText)
			.foregroundColor(Color.theme.accent)
			.frame(width: 343, height: 48)
			.background(Color.white)
			.cornerRadius(24)
			.overlay(
				RoundedRectangle(cornerRadius: 24)
					.stroke(Color.theme.accent, lineWidth: 1)
			)
	}
}

struct DarkFlexibleButton: ButtonStyle {
    var buttonFont: Font = .buttonText
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(buttonFont)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.frame(height: 48)
			.background(Color.theme.darkButton)
			.cornerRadius(24)
			.padding()
	}
}

extension View {
	func longFlexibleButtonStyle(disabled: Bool = false) -> some View {
		self
			.font(.buttonText)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.frame(height: 48)
			.background(disabled ? Color.theme.textInactive : Color.theme.darkButton)
			.disabled(disabled)
			.cornerRadius(24)
			.padding()
	}
}
