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
    fileprivate let MAIN_FLOW_KEY : String = "MainFlow"
    
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
        let mainflowCoordinator = MainFlowCoordinator(window: self.window)
        childCoordinators[MAIN_FLOW_KEY] = mainflowCoordinator
        mainflowCoordinator.delegate = self
        mainflowCoordinator.start()
    }
    
    func userDidRequestRegistration(mainFlowCoordinator: MainFlowCoordinator) {
        print("User wants to register")
    }
}


