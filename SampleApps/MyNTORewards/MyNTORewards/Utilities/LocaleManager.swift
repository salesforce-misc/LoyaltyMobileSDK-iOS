//
//  LocaleManager.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/28/23.
//

import Foundation
import SwiftUI
import Combine

class LocaleManager: ObservableObject {
    @Published var currentLocale: Locale = .current
    @Published var currentDateFormat: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        updateDateFormat()
        
        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { [weak self] _ in
                self?.currentLocale = .current
                self?.updateDateFormat()
            }
            .store(in: &cancellables)
    }
    
    private func updateDateFormat() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = currentLocale
        
        // Set the current date format to the one in Settings->General->Language & Region->Date Format
        // or fall back to AppSettings.Defaults.displayDateFormat
        currentDateFormat = dateFormatter.dateFormat ?? AppSettings.Defaults.displayDateFormat
    }
}
