//
//  AppDelegate.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/24/23.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        return true
    }
}
