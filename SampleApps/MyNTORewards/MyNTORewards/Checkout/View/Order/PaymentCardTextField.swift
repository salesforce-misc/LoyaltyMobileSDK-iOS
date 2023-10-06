//
//  PaymentCardTextField.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentCardTextField: View {
    @Binding var cardValue: String
    var body: some View {
        TextField("", text: $cardValue)
            .disableAutocorrection(true)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(height: 44)
            .background(Color.theme.lightSilverBackground)
            .foregroundColor(Color.theme.paymentCardText)
            .cornerRadius(8)
            .font(.dropDownText)
            .disabled(true)
    }
}

struct PaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardTextField(cardValue: .constant("1234"))
    }
}
