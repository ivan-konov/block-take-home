//
//  AppDelegate.swift
//  employee-list
//
//  Created by Ivan Konov on 12/22/22.
//

import UIKit
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupImageCaching()
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Image Caching Setup
    
    private func setupImageCaching() {
        SDImageCacheConfig.default.maxDiskSize = 150000000
        SDImageCacheConfig.default.maxMemoryCost = 50000000
        SDImageCacheConfig.default.maxDiskAge = .infinity
    }
}
