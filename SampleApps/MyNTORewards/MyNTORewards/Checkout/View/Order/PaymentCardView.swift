//
//  PaymentCardView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentCardView: View {
    var months: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    var years: [String] = ["2023", "20234", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2022"]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Card number")
                    .font(.voucherHederText)
                    .foregroundColor(Color(hex: "#181818"))
                HStack(spacing: 10) {
                    PaymentCardTextField(cardValue: .constant("0092"))
                    PaymentCardTextField(cardValue: .constant("0230"))
                    PaymentCardTextField(cardValue: .constant("0935"))
                    PaymentCardTextField(cardValue: .constant("2800"))
                }
            }
            VStack(alignment: .leading) {
                Text("Expiration Date")
                    .font(.voucherHederText)
                    .foregroundColor(Color(hex: "#181818"))
                HStack(spacing: 10) {
					ExpiryDatePickerView(selectedValue: .constant(months[0]), pickerViewInputValues: months)
                        .frame(height: 16)
                        .disabled(true)
					ExpiryDatePickerView(selectedValue: .constant(years[0]), pickerViewInputValues: years)
                        .frame(height: 16)
                        .disabled(true)
                    PaymentCardTextField(cardValue: .constant("298"))
                }
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white)
    }
}

struct PaymentCardView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardView()
    }
}
