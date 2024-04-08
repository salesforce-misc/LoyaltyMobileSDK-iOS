//
//  AdminAppSettingsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/21/24.
//

import SwiftUI

struct AdminAppSettingsView: View {
    
    @EnvironmentObject private var appSettingsVM: AdminAppSettingsViewModel
    
    var body: some View {
        Section {
            List {
                HStack {
                    Text("Program Name")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Program Name", 
                                                                         textFieldValue: appSettingsVM.loyaltyProgramName,
                                                                         fieldType: .loyaltyProgramNameField)) {
                        HStack {
                            Spacer()
                            Text(appSettingsVM.loyaltyProgramName)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                HStack {
                    Text("Currencies")
                    NavigationLink(destination: AppCurrencySettingView()) {
                        Text("")
                    }
                }
                
            }
            .navigationTitle("Loyalty Program")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    AdminAppSettingsView()
}
