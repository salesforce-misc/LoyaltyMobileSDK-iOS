//
//  AdminAppSettingsViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/24/24.
//

import Foundation

enum AdminAppSettingsField {
    case loyaltyProgramNameField
    case rewardCurrencyNameField
    case rewardCurrencyNameShortField
}

class AdminAppSettingsViewModel: ObservableObject {
    
    @Published var loyaltyProgramName = AppSettings.shared.getLoyaltyProgramName()
    @Published var rewardCurrencyName = AppSettings.shared.getRewardCurrencyName()
    @Published var rewardCurrencyNameShort = AppSettings.shared.getRewardCurrencyNameShort()
    
    private func updateLoyaltyProgramName(newValue: String) {
        if loyaltyProgramName != newValue {
            loyaltyProgramName = newValue
            UserDefaults.standard.setValue(newValue, forKey: AppSettings.Defaults.storedLoyaltyProgramNameKey)
        }
    }
    
    private func updateRewardCurrencyName(newValue: String) {
        if rewardCurrencyName != newValue {
            rewardCurrencyName = newValue
            UserDefaults.standard.setValue(newValue, forKey: AppSettings.Defaults.storedRewardCurrencyNameKey)
        }
    }
    
    private func updateRewardCurrencyNameShort(newValue: String) {
        if rewardCurrencyNameShort != newValue {
            rewardCurrencyNameShort = newValue
            UserDefaults.standard.setValue(newValue, forKey: AppSettings.Defaults.storedRewardCurrencyNameShortKey)
        }
    }
    
    func update(field: AdminAppSettingsField, newValue: String) {
        switch field {
        case .loyaltyProgramNameField:
            updateLoyaltyProgramName(newValue: newValue)
        case .rewardCurrencyNameField:
            updateRewardCurrencyName(newValue: newValue)
        case .rewardCurrencyNameShortField:
            updateRewardCurrencyNameShort(newValue: newValue)
            
        }
    }

}
