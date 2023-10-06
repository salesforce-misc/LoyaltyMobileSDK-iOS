//
//  LoyaltyPickerView.swift
//  CheckoutScreen
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct VoucherPickerView: View {
	@Binding var selectedValue: VoucherTitle
	
    var pickerViewInputValues: [VoucherTitle]
	
    var body: some View {
        Menu {
            Picker("", selection: $selectedValue) {
                ForEach(pickerViewInputValues, id: \.self) {
					Text($0.title)
                        .listRowSeparator(.hidden)
                }
            }
        } label: {
            customLabel
        }
        .listRowSeparator(.hidden)
    }
    
    var customLabel: some View {
        HStack {
            Spacer()
			Text(selectedValue.title)
                .font(.dropDownText)
            Spacer()
            Text("⌵")
                .font(.amountText)
                .offset(y: -4)
                .foregroundColor(.black)
                .padding(.trailing, 16)
        }
        .foregroundColor(Color.theme.textInactive)
        .frame(height: 44)
        .background(Color.theme.lightSilverBackground)
        .cornerRadius(16)
    }
}

struct VoucherPickerView_Previews: PreviewProvider {
    static var previews: some View {
		VoucherPickerView(selectedValue: .constant(dev.voucherTitles[0]), pickerViewInputValues: dev.voucherTitles)
    }
}
