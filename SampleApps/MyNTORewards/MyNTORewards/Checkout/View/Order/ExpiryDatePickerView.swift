//
//  ExpiryDatePickerView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 5/16/23.
//

import SwiftUI

struct ExpiryDatePickerView: View {
    @Binding var selectedValue: String
    
    var pickerViewInputValues: [String]
    
    var body: some View {
        Menu {
            Picker("", selection: $selectedValue) {
                ForEach(pickerViewInputValues, id: \.self) {
                    Text($0)
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
            Text(selectedValue)
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

struct ExpiryDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiryDatePickerView(selectedValue: .constant("1"), pickerViewInputValues: ["1", "2", "3"])
    }
}
