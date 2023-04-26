//
//  LoyaltyTextField.swift
//  LoyaltyForceSwift
//
//  Created by Anandhakrishnan Kanagaraj on 02/01/23.
//

import SwiftUI

enum SignUpTextFieldType {
    case firstName
    case lastName
    case email
    case phoneNumber
    case password
    case confirmPassword
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .phoneNumber:
            return .phonePad
        case .email:
            return .emailAddress
        default:
            return .namePhonePad
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .firstName:
            return "First name"
        case .lastName:
            return "Last name"
        case .email:
            return "Email address"
        case .phoneNumber:
            return "Mobile number"
        case .password:
            return "Password"
        case .confirmPassword:
            return "Confirm password"
        }
    }
    
    var regularExpression: String {
        switch self {
        case .firstName:
            return "^[a-zA-Z ]*$"
        case .lastName:
            return "^[a-zA-Z ]*$"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case .phoneNumber:
            return "[0-9]{10}$"
        case .password:
            return "^.{6,15}$"
        case .confirmPassword:
            return ""
        }
    }
    
    var accessibilityIdentifier: String {
        switch self {
        case .firstName:
            return AppAccessibilty.Signup.firstName
        case .lastName:
            return AppAccessibilty.Signup.lastName
        case .email:
            return AppAccessibilty.Signup.email
        case .phoneNumber:
            return AppAccessibilty.Signup.phone
        case .password:
            return AppAccessibilty.Signup.password
        case .confirmPassword:
            return AppAccessibilty.Signup.confirmPassword
        }
    }
    
    var errorMessage: String {
        switch self {
        case .firstName:
            return "Enter your first name without any special characters."
        case .lastName:
            return "Enter your last name without any special characters."
        case .email:
            return "Enter a valid email address."
        case .phoneNumber:
            return "Enter a valid 10 digit mobile number."
        case .password:
            return "Enter a password with at least 6 characters"
        case .confirmPassword:
            return "Ensure that your passwords match"
        }
    }

    func validate(text: String) -> Bool {
        return text.validateExpression(expression: self.regularExpression)
    }
}

struct LoyaltyTextField: View {
    
    @Binding private var inputText: String
    @State private var isValid: Bool = true
    
    private var textFieldType: SignUpTextFieldType
        
    init(textFieldType: SignUpTextFieldType, inputText: Binding<String>) {
        self._inputText = inputText
        self.textFieldType = textFieldType
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(textFieldType.placeHolderText, text: $inputText) { isEdit in
                if !isEdit {
                    isValid = textFieldType.validate(text: inputText)
                }
            }
            .accessibilityIdentifier(textFieldType.accessibilityIdentifier)
            .disableAutocorrection(true)
            .textFieldStyle(RegularTextFieldStyle())
            .keyboardType(textFieldType.keyboardType)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red, lineWidth: isValid ? 0 : 2)
                .padding(.horizontal)
            )
            if !isValid {
                Text(textFieldType.errorMessage)
                    .font(.labelText)
                    .foregroundColor(Color.red)
                    .padding(.leading)
                    .accessibilityIdentifier(textFieldType.accessibilityIdentifier + "_error")
            }
        }
    }
}

struct LoyaltyTextField_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyTextField(textFieldType: .firstName, inputText: .constant("value"))
    }
}
