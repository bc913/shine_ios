//
//  HomeScreenCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 10/29/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol HomeScreenCoordinatorDelegate : class {
    func userDidRequestRegistration(homeScreenCoordinator: HomeScreenCoordinator)
}

class HomeScreenCoordinator: Coordinator {
    
    weak var delegate : HomeScreenCoordinatorDelegate?
    
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let homeViewController = UITabBarController()
        
        // Timeline
        let timeLineVC = UIViewController()
        let timelineNavigationVC = UINavigationController(rootViewController: timeLineVC)
        let timelineTabrBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "converter-tabbar.png"), tag: 1)
        timelineNavigationVC.tabBarItem = timelineTabrBarItem
        
        // Map - Search
        let mapSearchViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        let mapSearchNavigationController = UINavigationController(rootViewController: mapSearchViewController)
        let mapSearchTabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "converter-tabbar.png"), tag: 2)
        mapSearchNavigationController.tabBarItem = mapSearchTabBarItem
        
        // Profile
        
        
        let profileVC = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        let userProfileViewModel = UserProfileViewModel()
        profileVC.viewModel = userProfileViewModel
        
        let profileNavigationVC = UINavigationController(rootViewController: profileVC)
        let profileTabrBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "converter-tabbar.png"), tag: 3)
        profileNavigationVC.tabBarItem = profileTabrBarItem
        
        homeViewController.viewControllers = [timelineNavigationVC, mapSearchNavigationController, profileNavigationVC]
        self.window.rootViewController = homeViewController
        
        
    }
}
