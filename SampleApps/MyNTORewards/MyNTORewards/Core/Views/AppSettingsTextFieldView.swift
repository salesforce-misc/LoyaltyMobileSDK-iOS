//
//  LoyaltyProgramNameView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/21/24.
//

import SwiftUI

struct AppSettingsTextFieldView: View {
    
    @EnvironmentObject private var appSettingsVM: AdminAppSettingsViewModel
    @State var settingName: String
    @State var textFieldValue: String
    private var fieldType: AdminAppSettingsField
    
    private var placeholder: String = ""
    
    init(settingName: String, textFieldValue: String, fieldType: AdminAppSettingsField) {
        self.settingName = settingName
        self.textFieldValue = textFieldValue
        self.fieldType = fieldType
        self.placeholder = textFieldValue
    }
    
    var body: some View {
        Section {
            List {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                    TextField(placeholder, text: $textFieldValue)
                        .background(.white)
                        .cornerRadius(10)
                    
                    if !textFieldValue.isEmpty {
                        Button(action: {
                            self.textFieldValue = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle(settingName)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear {
            if textFieldValue != "" {
                appSettingsVM.update(field: fieldType, newValue: textFieldValue)
            }
        }
    }
}

#Preview {
    AppSettingsTextFieldView(settingName: "Program Name", textFieldValue: "NTO Insider", fieldType: .loyaltyProgramNameField)
}
