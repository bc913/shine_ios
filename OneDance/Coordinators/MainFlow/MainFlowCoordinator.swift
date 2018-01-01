//
//  MainFlowCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol MainFlowCoordinatorDelegate : class {
    func userDidRequestRegistration(mainFlowCoordinator: MainFlowCoordinator)
}

class MainFlowCoordinator: Coordinator {
    
    fileprivate let HOME_TAB_KEY : String = "HomeScreen"
    fileprivate let EXPLORE_TAB_KEY : String = "Explore"
    fileprivate let PROFILE_TAB_KEY : String = "Profile"
    
    weak var delegate : MainFlowCoordinatorDelegate?
    
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let homeViewController = UITabBarController()

        
        // Home
        let timelineNavigationVC = UINavigationController()
        let homeScreenCoordinator = HomeScreenContainerCoordinator(containerNavController: timelineNavigationVC)
        childCoordinators[HOME_TAB_KEY] = homeScreenCoordinator
        homeScreenCoordinator.start()
        
        let timelineTabrBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "converter-tabbar.png"), tag: 1)
        timelineNavigationVC.tabBarItem = timelineTabrBarItem
        
        // Map - Search
        let mapSearchViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        let mapSearchNavigationController = UINavigationController(rootViewController: mapSearchViewController)
        let mapSearchTabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "converter-tabbar.png"), tag: 2)
        mapSearchNavigationController.tabBarItem = mapSearchTabBarItem
        
        // Profile
        
        
        let profileVC = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        let userProfileViewModel = UserViewModel(mode: .viewOnly, id: "", isMyProfile: true)
        profileVC.viewModel = userProfileViewModel
        
        let profileNavigationVC = UINavigationController(rootViewController: profileVC)
        let profileTabrBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "converter-tabbar.png"), tag: 3)
        profileNavigationVC.tabBarItem = profileTabrBarItem
        
        homeViewController.viewControllers = [timelineNavigationVC, mapSearchNavigationController, profileNavigationVC]
        self.window.rootViewController = homeViewController
        
        
    }
}
