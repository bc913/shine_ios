//
//  PersistanceManager.swift
//  OneDance
//
//  Created by Burak Can on 10/18/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

struct PersistanceManager {
    
    struct User {
        static func saveLoginCredentials(userId: String, secretID: String? = nil){
            let defaults = UserDefaults.standard
            
            defaults.set(userId, forKey: "UserID")
            if secretID != nil {
                defaults.set(secretID, forKey: "SecretID")
            }
            
            
        }
        
        static var userId : String? {
            get {
                return UserDefaults.standard.string(forKey: "UserID")
            }
            
        }
        
        static var secretId : String? {
            get {
                return UserDefaults.standard.string(forKey: "SecretID")
            }
            
        }
        
        static var isLoggedIn : Bool {
            get {
                return self.secretId != nil
            }
        }
        

    }
    
    struct Device {
        static var id : String {
            get {
                return UIDevice.current.identifierForVendor!.uuidString
            }
        }
        
        static var brand : String {
            get {
                return "Apple"
            }
        }
        
        static var model : String {
            get {
                return UIDevice.current.modelName
            }
        }
        
        static var osVersion : String {
            get {
                return UIDevice.current.systemVersion
            }
        }
        
        static var appVersion : String {
            get {
                return "1.0.0"
            }
        }
        
        static var systemName : String {
            get {
                return UIDevice.current.systemName
            }
        }
        
        static var systemVersion : String {
            get {
                return UIDevice.current.systemVersion
            }
        }
        
    }
}
