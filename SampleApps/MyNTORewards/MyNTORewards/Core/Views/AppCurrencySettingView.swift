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
                    Text("Redeemable Currency")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Redeemable Currency",
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
                    Text("Redeemable Currency Alias")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Redeemable Currency Alias",
                                                                         textFieldValue: appSettingsVM.rewardCurrencyNameShort,
                                                                         fieldType: .rewardCurrencyNameShortField)) {
                        HStack {
                            Spacer()
                            Text(appSettingsVM.rewardCurrencyNameShort)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                HStack {
                    Text("Tier Qualification Currency")
                    NavigationLink(destination: AppSettingsTextFieldView(settingName: "Tier Qualification Currency",
                                                                         textFieldValue: appSettingsVM.tierCurrencyName,
                                                                         fieldType: .tierCurrencyNameField)) {
                        HStack {
                            Spacer()
                            Text(appSettingsVM.tierCurrencyName)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
            }
            .navigationTitle("Currencies")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AppCurrencySettingView()
        .environmentObject(AdminAppSettingsViewModel())
}
