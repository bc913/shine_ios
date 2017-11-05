//
//  PersistanceManager.swift
//  OneDance
//
//  Created by Burak Can on 10/18/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

struct PersistanceManager {
    
    struct User {
        static func saveLoginCredentials(userId: String, secretID: String){
            let defaults = UserDefaults.standard
            
            defaults.set(userId, forKey: "UserID")
            defaults.set(secretID, forKey: "SecretID")
            
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
}
