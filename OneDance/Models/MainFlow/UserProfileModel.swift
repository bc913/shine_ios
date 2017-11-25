//
//  UserProfileModel.swift
//  OneDance
//
//  Created by Burak Can on 11/2/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol UserProfileModelType {
    
    var userID : String { get set }
    var privateAccount : Bool { get set }
    
    var userName : String { set get }
    var fullName : String { get set }
    var slogan : String { get set }
    var bioLink : String { get set }
    var email : String { get set }
    
    var followerCounter : String { get set }
    var followingCounter : String { get set }
    
    var profilePhotoUrl : String { get set }
    var danceTypes : Array<IDanceType> { get set }
    
    var djProfile : DJProfileModelType? { get set }
    var instructor : InstructorProfileModelType? { get set }
    
    init?(json:[String:Any])
}

struct UserProfileModel : UserProfileModelType {
    
    var userID : String = ""
    var privateAccount: Bool = false
    
    var userName: String = ""
    var fullName: String = ""
    var slogan: String = ""
    var bioLink: String = ""
    var email: String = ""
    
    var followerCounter: String = ""
    var followingCounter: String = ""
    
    var profilePhotoUrl : String = ""
    var danceTypes = Array<IDanceType>()
    
    var djProfile : DJProfileModelType?
    var instructor : InstructorProfileModelType?
    
    
}

extension UserProfileModel {
    
    init?(json:[String:Any]){
        
        if let accountPrivate = json["privateAccount"] as? Bool {
            self.privateAccount = accountPrivate
        }
        
        if let userID = json["userId"] as? String {
            self.userID = userID
        }
        
        if let userName = json["username"] as? String {
            self.userName = userName
        }
        
        if let fullName = json["fullname"] as? String {
            self.fullName = fullName
        }
        
        if let email = json["email"] as? String {
            self.email = email
        }
        
        if let slogan = json["bio"] as? String {
            self.slogan = slogan
        }
        
        if let bioLink = json["website"] as? String {
            self.bioLink = bioLink
        }
        
        if let dances = json["selectedDanceTypes"] as? [[String:Any]] {
            for danceObj in dances {
                self.danceTypes.append(DanceType(json: danceObj)!)
            }
        }
        
        if let profilePhoto = json["profilePhoto"] as? [String:Any] {
            
            if let standardImage = profilePhoto["standardImage"] as? [String:Any], let url = standardImage["url"] as? String{
                self.profilePhotoUrl = url
            } else {
                self.profilePhotoUrl = ""
            }
        
        } else {
            self.profilePhotoUrl = ""
        }    
        
    }
}
