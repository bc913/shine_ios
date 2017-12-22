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

struct ClientInfo {
    
    var id : String = ""
    var brand : String = ""
    var model : String = ""
    var osVersion : String = ""
    var appVersion : String = ""
}


extension ClientInfo : JSONDecodable {
    
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
    var userId : String = "" //ID of the installation, received in add new device API
    var username : String = ""
    var fullname : String = ""
    var email : String = ""
    var password : String = ""
    
    var facebookModel : FacebookUserModel = FacebookUserModel()
    var client : ClientInfo = ClientInfo()
    
}

extension RegistrationModel : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "userId" : self.userId,
            "username" : self.username,
            "fullname" : self.fullname,
            "email" : self.email,
            "password" : self.password,
            "facebook" : self.facebookModel.jsonData,
            "client" : self.client.jsonData
        ]
    }
}



