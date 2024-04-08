//
//  AppCurrencySettingView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/21/24.
//

import SwiftUI

struct AppCurrencySettingView: View {
    
    @EnvironmentObject private var appSettingsVM: AdminAppSettingsViewModel
    
    var body: some View {
        Section {
            List {
                HStack {
                    Text("Currency Name")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Currency Name", 
                                                                         textFieldValue: appSettingsVM.rewardCurrencyName,
                                                                         fieldType: .rewardCurrencyNameField)) {
                        HStack {
                            Spacer()
                            Text(appSettingsVM.rewardCurrencyName)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                HStack {
                    Text("Currency Name Short")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Currency Name Short", 
                                                                         textFieldValue: appSettingsVM.rewardCurrencyNameShort,
                                                                         fieldType: .rewardCurrencyNameShortField)) {
                        HStack {
                            Spacer()
                            Text(appSettingsVM.rewardCurrencyNameShort)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    AppCurrencySettingView()
}
