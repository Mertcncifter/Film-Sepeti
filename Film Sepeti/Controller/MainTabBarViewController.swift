//
//  MainTabBarViewController.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    
    // MARK: - Properties
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        configureViewControllers()
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    

    func configureViewControllers(){
        let home = HomeViewController()
        home.viewModel = HomeViewModel()
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: home, title: "Filmler")
        
        let watch = WatchListViewController()
        watch.viewModel = WatchListViewModel()
        let nav2 = templateNavigationController(image: UIImage(systemName: "list.dash"), rootViewController: watch, title: "Listem")
        
        tabBar.tintColor = .label
        setViewControllers([nav1,nav2], animated: true)
    }
    
    func templateNavigationController(image : UIImage?, rootViewController : UIViewController, title: String) ->UIViewController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.title = title
        return nav
    }
}
