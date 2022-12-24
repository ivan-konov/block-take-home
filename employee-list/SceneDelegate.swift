//
//  SceneDelegate.swift
//  employee-list
//
//  Created by Ivan Konov on 12/22/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let employeeListView = EmployeeListViewController()
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = employeeListView
        self.window?.makeKeyAndVisible()
    }
}

