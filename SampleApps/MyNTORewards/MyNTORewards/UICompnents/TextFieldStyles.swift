//
//  TextFieldStyles.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/23/22.
//

import SwiftUI

struct RegularTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .font(.subheadline)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.textFieldBorder, lineWidth: 1))
            .textInputAutocapitalization(.never)
            .padding([.leading, .trailing])
    }
}

struct GrayedTextFieldStyle: TextFieldStyle {
	
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.padding()
			.font(.subheadline)
			.background(Color.theme.commentsTextFieldBackground)
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.commentsTextFieldBorderColor, lineWidth: 1))
			.textInputAutocapitalization(.never)
			.padding([.leading, .trailing])
	}
}

