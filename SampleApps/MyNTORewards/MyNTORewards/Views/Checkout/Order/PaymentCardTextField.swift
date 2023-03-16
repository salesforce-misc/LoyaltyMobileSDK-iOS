//
//  PaymentCardTextField.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentCardTextField: View {
    var body: some View {
        TextField("", text: .constant("1234"))
            .disableAutocorrection(true)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(height: 44)
            .background(Color(hex: "#F4F6F9"))
            .foregroundColor(Color(hex: "#747B84"))
            .cornerRadius(8)
            .font(.dropDownText)
    }
}

struct PaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardTextField()
    }
}
