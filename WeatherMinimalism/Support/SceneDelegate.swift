//
//  SceneDelegate.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let winScene = (scene as? UIWindowScene) else { return }

        let vc = UINavigationController(rootViewController: WeatherViewController())
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let userDefaults = UserDefaults.standard
        window?.overrideUserInterfaceStyle = userDefaults.selectedTheme.userInterfaceStyle
    }
}

