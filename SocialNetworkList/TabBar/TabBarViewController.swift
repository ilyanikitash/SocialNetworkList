//
//  TabBarViewController.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//
import UIKit

final class TabBarViewController: UITabBarController {
    
    private var viewControllersList: [UIViewController] {
        let mainVC = MainScreenViewController()
        let mainNavController = UINavigationController(rootViewController: mainVC)
            
        mainNavController.setNavigationBarHidden(false, animated: false)
        mainNavController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "person"), tag: 0)
            
        let secondVC = SavedPostsViewController()
        secondVC.tabBarItem = UITabBarItem(title: "Сохраненное", image: UIImage(systemName: "bookmark"), tag: 1)
            
        return [mainNavController, secondVC]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .customWhite
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        viewControllers = viewControllersList
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
    }
}
