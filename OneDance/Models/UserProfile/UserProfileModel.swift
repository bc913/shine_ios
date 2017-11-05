//
//  UserProfileModel.swift
//  OneDance
//
//  Created by Burak Can on 11/2/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol UserProfileModelType {
    
    var userName : String { set get }
    var fullName : String { get set }
    var slogan : String { get set }
    var bioLink : String { get set }
    
    var followerCounter : String { get set }
    var followingCounter : String { get set }
    
    var profilePhotoUrl : String { get set }
    var danceTypes : Array<IDanceType> { get set }
    
    var djProfile : DJProfileModelType? { get set }
    var instructor : InstructorProfileModelType? { get set }
    
    init?(json:[String:Any])
}

struct UserProfileModel : UserProfileModelType {
    
    var userName: String
    var fullName: String
    var slogan: String
    var bioLink: String
    
    var followerCounter: String
    var followingCounter: String
    
    var profilePhotoUrl : String
    var danceTypes = Array<IDanceType>()
    
    var djProfile : DJProfileModelType?
    var instructor : InstructorProfileModelType?
    
    init(userName: String, fullName: String, slogan: String, bioLink: String,
         followerCounter: String, followingCounter: String, photoUrl: String,
         dj: DJProfileModelType?, instructor: InstructorProfileModelType?) {
        
        self.userName = userName
        self.fullName = fullName
        self.slogan = slogan
        self.bioLink = bioLink
        
        self.followerCounter = followerCounter
        self.followingCounter = followingCounter
        
        self.profilePhotoUrl = photoUrl
        
        self.djProfile = dj
        self.instructor = instructor
    }
}

extension UserProfileModel {
    
    init?(json:[String:Any]){
        
        if let userName = json["username"] as? String, let fullName = json["fullname"] as? String,
            let bioLink = json["website"] as? String, let slogan = json["bio"] as? String,
            let dances = json["danceTypes"] as? [[String:Any]]/*,
            let photoUrl = json["photoUrl"] as? String,
            let dj = json["djProfile"] as? [String:Any], let instructor = json["instructorProfile"] as? [String:Any]*/{
            
                self.userName = userName
                self.fullName = fullName
                self.slogan = slogan
                self.bioLink = bioLink
                
                self.followerCounter = "3.2k"
                self.followingCounter = "123"
                
                self.profilePhotoUrl = ""
                for danceObj in dances {
                    self.danceTypes.append(DanceType(json: danceObj)!)
                }
                    
                self.djProfile = nil
                self.instructor = nil
            
//            self.djProfile = DJProfileModel(json: dj)
//            self.instructor = InstructorProfileModel(json: instructor)
            
        } else{
            return nil
        }
        
    }
}
