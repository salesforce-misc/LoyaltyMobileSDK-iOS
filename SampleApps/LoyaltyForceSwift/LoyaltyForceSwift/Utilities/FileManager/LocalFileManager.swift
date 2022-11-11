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
    
    func saveData<T: Codable>(item: T, id: String, folderName: String? = nil, expiry: Expiry = .never) {
        
        let folderName = folderName ?? String(describing: T.self)
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for data
        guard let url = getURLForItem(id: id, folderName: folderName) else { return }
        
        // create an Entry for saving
        let entry = Entry(object: item, expiry: expiry, filePath: url)
        
        // save data to path
        do {
            let data = try JSONEncoder().encode(entry)
            try data.write(to: url, options: .atomic) // use `atomic`, will overwrite if already exists
            print("Data saved at location: \(url.absoluteString)")
        } catch let error {
            print("Error saving member data. Member Id: \(id). \(error)")
        }
    }
    
    func getData<T: Codable>(type: T.Type, id: String, folderName: String? = nil) -> T? {
        
        let folderName = folderName ?? String(describing: T.self)
        guard
            let url = getURLForItem(id: id, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        let data = FileManager.default.contents(atPath: url.path)
        guard let data = data else {
            print("Error retrieving data. No data found for \(id)")
            return nil
        }
        do {
            let entry = try JSONDecoder().decode(Entry<T>.self, from: data)
            
            // check whether item is expired or not
            if entry.expiry.isExpired {
                // remove data from disk
                deleteData(url: entry.filePath)
                return nil
            }
            return entry.object
        } catch let error {
            print("Error retrieving data. Decoding error: \(error)")
            return nil
        }
        
    }
    
    func removeData<T>(type: T.Type, id: String, folderName: String? = nil) {
        
        let folderName = folderName ?? String(describing: T.self)
        guard
            let url = getURLForItem(id: id, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        deleteData(url: url)
    }
    
    func removeAllAppData() {
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error deleting all data - BundleID or URL error")
            return
        }
        let dataFolder = url.appendingPathComponent(bundleID)
        deleteData(url: dataFolder)
    }
    
    private func deleteData(url: URL) {
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
    
    private func getURLForItem(id: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent("\(id).json")
    }
}
