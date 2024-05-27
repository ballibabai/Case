//
//  TabBarController.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 26.05.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let homeVC = HomeVC()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let basketVC = BasketVC()
        basketVC.view.backgroundColor = .white
        let cartNavController = UINavigationController(rootViewController: basketVC)
        cartNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        
        let favoritesVC = FavoriteVC()
        favoritesVC.view.backgroundColor = .white
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
        
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .white
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        viewControllers = [homeNavController, cartNavController, favoritesNavController, profileNavController]
    }
}
