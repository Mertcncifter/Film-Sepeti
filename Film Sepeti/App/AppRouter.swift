//
//  AppRouter.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import UIKit

final class AppRouter {
    
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func start() {
        window.rootViewController = MainTabBarViewController()
        window.makeKeyAndVisible()
    }
}
