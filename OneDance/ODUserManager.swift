//
//  ODUserManager.swift
//  OneDance
//
//  Created by Burak Can on 7/9/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

// This is a factory class to create and modify ODUser objects
// TODO: Implement factory protocol
// TODO: Use dependency injection to use this in view controllers. Pass them to initializers to create immutable state

/*
    SINGLETON: In Swift, is just necessary to use a static type property, which is guaranteed to be lazily initialized only once, even when accessed across multiple threads simultaneously: SO, NO NEED TO Dispatch_once
*/

class ODUserManager {
    private init (){}
    
    // static let instance = ODUserManager() // Another singleton way
    
    private static var instanceUserManager : ODUserManager {
        let userManager = ODUserManager()
        
        // Configuration
        
        return userManager
    }
    
    
    class func instance() -> ODUserManager {
        return instanceUserManager
    }
}

