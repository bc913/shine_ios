//
//  AppCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 9/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit


class AppCoordinator : Coordinator {
    
    // Constants
    fileprivate let AUTHENTICATION_KEY: String  = "Authentication"
    fileprivate let HOME_SCREEN_KEY : String = "HomeScreen"
    
    // Properties
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    //Ctors
    init(window:UIWindow) {
        self.window = window
    }
    
    var isLoggedIn : Bool = false
    
    // Coordinator
    func start() {
        if !PersistanceManager.User.isLoggedIn {
            showAuthentication()
        } else{
            showHomeScreen()
        }
        
    }
}

extension AppCoordinator : MainAuthCoordinatorDelegate {
    
    
    func showAuthentication(){
        
        let authenticationCoordinator = MainAuthenticationCoordinator(window: window)
        childCoordinators[AUTHENTICATION_KEY] = authenticationCoordinator
        authenticationCoordinator.delegate = self
        authenticationCoordinator.start()
        
    }
    
    func mainAuthCoordinatorDidFinish(authenticationCoordinator: MainAuthenticationCoordinator) {
        print("AppCoordinator :: mainAuthCoordinatorDidFinish")
        self.showHomeScreen()
    }
    
    func mainAuthCoordinatorDidSelectSkip(authenticationCoordinator: MainAuthenticationCoordinator) {
        self.showHomeScreen()
    }
    
}

extension AppCoordinator : MainFlowCoordinatorDelegate {
    
    func showHomeScreen(){
        let homeScreenCoordinator = MainFlowCoordinator(window: self.window)
        childCoordinators[HOME_SCREEN_KEY] = homeScreenCoordinator
        homeScreenCoordinator.delegate = self
        homeScreenCoordinator.start()
    }
    
    func userDidRequestRegistration(mainFlowCoordinator: MainFlowCoordinator) {
        print("User wants to register")
    }
}


