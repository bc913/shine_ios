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
    
    // Properties
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    //Ctors
    init(window:UIWindow) {
        self.window = window
    }
    
    
    func showAuthentication(){
        print("AppCoordinator :: showAuth()")
    }
    
    var isLoggedIn : Bool = false
    
    // Coordinator
    func start() {
        if !isLoggedIn {
            showAuthentication()
        }
        
    }
    
    
    
}
