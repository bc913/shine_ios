//
//  Authentication.swift
//  OneDance
//
//  Created by Burak Can on 12/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

//============
// Login
//============

struct LoginModel {
    
    var username : String?
    var email : String?
    var password : String = ""
    
    init?(username: String?, email: String?, password: String) {
        
        if username == nil && email == nil {
            return nil
        }
        
        if username != nil && email != nil {
            self.username = nil
        } else {
            self.username = username
        }
        
        
        self.email = email
        self.password = password
    }
    
}

extension LoginModel : JSONDecodable {
    
    var jsonData : [String:Any] {
        return [
            "username" : self.username ?? "",
            "email" : self.email ?? "",
            "password" : self.password
        ]
    }
}

//============
// Client
//============

struct DeviceInfo {
    
    var id : String = PersistanceManager.Device.id
    var brand : String = PersistanceManager.Device.brand
    var model : String = PersistanceManager.Device.model
    var osVersion : String = PersistanceManager.Device.osVersion
    var appVersion : String = PersistanceManager.Device.appVersion
}


extension DeviceInfo : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        return [
            "id" : self.id,
            "brand" : self.brand,
            "model" : self.model,
            "osVersion": self.osVersion,
            "appVersion" : self.appVersion
        ]
    }
}


//============
// Facebook
//============

struct FacebookUserModel {
    
    var userId : String = ""
    var accessToken : String = ""
}

extension FacebookUserModel : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "userId" : self.userId,
            "accessToken" : self.accessToken
        ]
    }
}

//============
// Registration
//============

struct RegistrationModel {
    let userId : String = PersistanceManager.User.userId! //ID of the installation, received in add new device API
    var username : String = ""
    var fullname : String = ""
    var email : String = ""
    var password : String = ""
    
    var facebookModel : FacebookUserModel?
    let client : DeviceInfo = DeviceInfo()
    
}

extension RegistrationModel : JSONDecodable {
    
    var jsonData : [String:Any] {
        return [
            "userId" : self.userId,
            "username" : self.username,
            "fullname" : self.fullname,
            "email" : self.email,
            "password" : self.password,
            "facebook" : self.facebookModel?.jsonData ?? [String:Any](),
            "client" : self.client.jsonData
        ]
    }
}



