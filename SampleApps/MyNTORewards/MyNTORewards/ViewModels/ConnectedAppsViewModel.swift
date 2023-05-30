//
//  ConnectedAppsViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/13/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class ConnectedAppsViewModel<KeychainManagerType: KeychainManagerProtocol>: ObservableObject where KeychainManagerType.T == ForceConnectedApp {
        
    @Published var selectedInstance: String {
        didSet {
            UserDefaults.standard.setValue(selectedInstance, forKey: AppSettings.Defaults.storedInstanceURLKey)
        }
    }
    @Published var savedApps: [ForceConnectedApp] = []
    
    init() {
        if let storedValue = UserDefaults.standard.string(forKey: AppSettings.Defaults.storedInstanceURLKey) {
            selectedInstance = storedValue
        } else {
            selectedInstance = AppSettings.shared.connectedApp.instanceURL
        }
        
        guard let app = retrieveApp(instance: selectedInstance) else {
            let initApp = AppSettings.shared.connectedApp
            saveApp(connectedApp: initApp)
            updateSavedApps()
            return
        }
        saveApp(connectedApp: app)
        updateSavedApps()
    }
    
    func saveApp(connectedApp: ForceConnectedApp) {
        do {
            try KeychainManagerType.save(item: connectedApp)
        } catch {
            Logger.error("Failed to save \(connectedApp.connectedAppName) info into Keychain - \(error.localizedDescription)")
        }
    }
    
    func updateSavedApps() {
        
        do {
            savedApps = try KeychainManagerType.retrieveAll()
        } catch {
            Logger.error("Failed to update saved connected apps - \(error.localizedDescription)")
        }

    }
    
    func deleteApp(connectedApp: ForceConnectedApp) {
        do {
            try KeychainManagerType.delete(for: connectedApp.instanceURL)
        } catch {
            Logger.error("Failed to delete \(connectedApp.connectedAppName) info from Keychain - \(error.localizedDescription)")
        }
    }
    
    func updateSelectedInstance(instance: String) {
        selectedInstance = instance
    }
    
    func retrieveApp(instance: String) -> ForceConnectedApp? {
        do {
            return try KeychainManagerType.retrieve(for: instance)
        } catch {
            Logger.error("Failed to retrieve info for \(instance) from Keychain - \(error.localizedDescription)")
            return nil
        }
    }
    
}
