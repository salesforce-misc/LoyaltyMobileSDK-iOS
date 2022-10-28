//
//  LocalFileManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/19/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    func saveData<T: Encodable>(item: T, id: String) {
        
        let folderName = String(describing: T.self)
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for data
        guard let url = getURLForItem(type: type(of: item), id: id, folderName: folderName) else { return }
        
        // save data to path
        do {
            let data = try JSONEncoder().encode(item)
            try data.write(to: url)
            print("Data saved at location: \(url.absoluteString)")
        } catch let error {
            print("Error saving member data. Member Id: \(id). \(error)")
        }
    }
    
    func getData<T: Decodable>(type: T.Type, id: String) -> T? {
        
        let folderName = String(describing: T.self)
        guard
            let url = getURLForItem(type: type, id: id, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        let memberData = FileManager.default.contents(atPath: url.path)
        guard let memberData = memberData else {
            print("Error retrieving member data. No data found for \(id)")
            return nil
        }
        do {
            let member = try JSONDecoder().decode(T.self, from: memberData)
            return member
        } catch let error {
            print("Error retrieving data. Decoding error: \(error)")
            return nil
        }
        
    }
    
    func removeData<T>(type: T.Type, id: String) {
        
        let folderName = String(describing: T.self)
        guard
            let url = getURLForItem(type: type, id: id, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch let error {
            print("Error deleting data. \(error)")
        }
    }
    
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let folderPath = bundleID + "/" + folderName
        return url.appendingPathComponent(folderPath)
    }
    
    private func getURLForItem<T>(type: T.Type, id: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(id + "." + String(describing: type.self))
    }
}
