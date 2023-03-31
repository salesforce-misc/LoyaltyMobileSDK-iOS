//
//  LocalFileManager.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/19/22.
//

import Foundation
import SwiftUI

public class LocalFileManager {
    
    public static let instance = LocalFileManager()
    private let defaultImagesFolder = "Images"
    private init() {}
    
    public func saveData<T: Codable>(item: T, id: String, folderName: String? = nil, expiry: Expiry = .never) {
        
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
            try data.write(to: url, options: [.atomic, .completeFileProtection]) // use `atomic`, will overwrite if already exists
            print("Data saved at location: \(url.absoluteString)")
        } catch let error {
            print("Error saving member data. Member Id: \(id). \(error)")
        }
    }
    
    public func getData<T: Codable>(type: T.Type, id: String, folderName: String? = nil) -> T? {
        
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
    
    public func removeData<T>(type: T.Type, id: String, folderName: String? = nil) {
        
        let folderName = folderName ?? String(describing: T.self)
        guard
            let url = getURLForItem(id: id, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        deleteData(url: url)
    }
    
    public func removeAllAppData() {
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error deleting all data - BundleID or URL error")
            return
        }
        let dataFolder = url.appendingPathComponent(bundleID)
        deleteData(url: dataFolder)
    }
    
    public func saveImage(image: UIImage, imageName: String, folderName: String? = nil, expiry: Expiry = .never) {
        
        let folderName = folderName ?? defaultImagesFolder
        
        guard let imageData = image.pngData() else {
            print("Error saving image. The image format is incorrect.")
            return
        }
        
        saveData(item: imageData, id: imageName, folderName: folderName, expiry: expiry)
    }
    
    public func getImage(imageName: String, folderName: String? = nil) -> UIImage? {
        
        let folderName = folderName ?? defaultImagesFolder
        
        guard let imageData = getData(type: Data.self, id: imageName, folderName: folderName) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    public func removeImage(imageName: String, folderName: String? = nil) {
        let folderName = folderName ?? defaultImagesFolder
        removeData(type: Data.self, id: imageName, folderName: folderName)
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
        return folderURL.appendingPathComponent(id)
    }
}
