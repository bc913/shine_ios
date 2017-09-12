//
//  Coordinator.swift
//  OneDance
//
//  Created by Burak Can on 9/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol Coordinator : class {
    
    func start()
    var childCoordinators : [String : Coordinator] { get set }
    
}

// Apply extension for default methods for add and remove child coordinator
