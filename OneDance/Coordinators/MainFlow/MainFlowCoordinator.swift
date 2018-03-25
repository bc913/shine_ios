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
        
        let timelineTabrBarItem = UITabBarItem(title: nil, image: UIImage(named:"home-tab"), tag: 1)
        //timelineTabrBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        timelineNavigationVC.tabBarItem = timelineTabrBarItem
        
        // Map - Search
//        let mapSearchViewController = MapViewController(nibName: "MapViewController", bundle: nil)
//        let mapSearchNavigationController = UINavigationController(rootViewController: mapSearchViewController)
//        let mapSearchTabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "converter-tabbar.png"), tag: 2)
//        mapSearchNavigationController.tabBarItem = mapSearchTabBarItem
        
        // Search
        let exploreVc = SearchExploreViewController(nibName: "SearchExploreViewController", bundle: nil)
        let exploreNVC = UINavigationController(rootViewController: exploreVc)
        
        let exploreTabrBarItem = UITabBarItem(title: nil, image: UIImage(named: "explore-tab"), tag: 2)
        exploreNVC.tabBarItem = exploreTabrBarItem
        
        // Profile
        let profileNavigationVC = UINavigationController()
        let profileScreenCoordinator = ProfileTabCoordinator(containerNavController: profileNavigationVC)
        childCoordinators[PROFILE_TAB_KEY] = profileScreenCoordinator
        profileScreenCoordinator.start()
        
        let profileTabrBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile-tab"), tag: 3)
        profileNavigationVC.tabBarItem = profileTabrBarItem
        
        homeViewController.viewControllers = [timelineNavigationVC, exploreNVC, profileNavigationVC]
        
        for tab in homeViewController.tabBar.items!{
            tab.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0) // hack to center image in the tab
            tab.titlePositionAdjustment = UIOffsetMake(0, 1000) // Hack to hide title
        }
        self.window.rootViewController = homeViewController
        
        
    }
}
