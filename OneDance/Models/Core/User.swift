//
//  User.swift
//  OneDance
//
//  Created by Burak Can on 12/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

//=============
// UserLite
//=============


protocol UserLiteType {
    
    var userName : String { get set }
    var fullName : String { get set }
    var userId : String { get set }
    
    var profilePhoto : ImageType? { get set }
}

// This is used to store user, owner, instructor and dj info from Event API responses
struct UserLite : UserLiteType{
    
    // Required
    var userName : String = ""
    var fullName : String = ""
    var userId : String = ""
    
    // Optional
    var profilePhoto : ImageType?
    
    init() { }
    init(userName : String, fullName: String, userID: String, photo: ImageType?) {
        
        self.userName = userName
        self.fullName = fullName
        self.userId = userID
        self.profilePhoto = photo
    }
    
}

extension UserLite {
    
    init?(json:[String:Any]){
        
        guard let userName = json["username"] as? String, let fullName = json["fullname"] as? String,
            let userId = json["userId"] as? String else
        {
            return nil
        }
        
        self.userName = userName
        self.fullName = fullName
        self.userId = userId
        
        if let photo = json["profilePhoto"] as? [String:Any] {
            self.profilePhoto = MediaImage(json: photo)
        }
    }
    
}

extension UserLite : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        let photo = self.profilePhoto as? MediaImage
        
        return [
            "userId" : self.userId,
            "username" : self.userName,
            "fullname" : self.fullName,
            "profilePhoto" : photo?.jsonData ?? NSNull()
        ]
    }
}

//=============
// Instructor
//=============

protocol InstructorProfileType {
    
    var bio : String { get set }
    var danceTypes : [IDanceType] { get set }
    var sinceYear : Int { get set }
    var canFreelance : Bool { get set }
    var relatedOrganizations : [OrganizationLiteType]? { get set }
    
}

struct InstructorProfile : InstructorProfileType {
    
    var bio: String = ""
    var danceTypes = [IDanceType]()
    var sinceYear: Int = -1
    var canFreelance: Bool = false
    var relatedOrganizations : [OrganizationLiteType]?
}

extension InstructorProfile {
    
    init?(json:[String:Any]) {
        
        guard let dances = json["selectedDanceTypes"] as? [[String:Any]] else {
            return nil
        }
        
        for dancObj in dances {
            self.danceTypes.append(DanceType(json: dancObj)!)
        }
        
        if let bio = json["instructorBio"] as? String {
           self.bio = bio
        }
        
        if let since = json["sinceYear"] as? Int {
            self.sinceYear = since
        }
        
        if let isFreelance = json["freelance"] as? Bool {
            self.canFreelance = isFreelance
        }
        
        if let relatedOrgs = json["relatedOrganizationLites"] as? [[String:Any]] {
            
            self.relatedOrganizations = [OrganizationLite]()
            
            for org in relatedOrgs {
                self.relatedOrganizations?.append(OrganizationLite(json: org)!)
            }
        }
    }
}

extension InstructorProfile : JSONDecodable {
    var jsonData : [String:Any] {
        
        // Dances
        var dances : [[String:Any]]?
        for dance in self.danceTypes {
            
            dances = [[String:Any]]()
            dances?.reserveCapacity(self.danceTypes.count)
            
            if let danceObj = dance as? DanceType {
                dances?.append(danceObj.jsonData)
            }
        }
        
        // Organizations
        var relatetedOrgs : [[String:Any]]?
        if let relatedOrganizations = self.relatedOrganizations {
            
            relatetedOrgs = [[String:Any]]()
            relatetedOrgs?.reserveCapacity(relatedOrganizations.count)
            
            for org in relatedOrganizations {
                if let orgLite = org as? OrganizationLite {
                    relatetedOrgs?.append(orgLite.jsonData)
                }
            }
        }
        
        return [
            "instructorBio" : self.bio,
            "selectedDanceTypes" : (dances == nil || dances!.isEmpty) ? NSNull() : dances!,
            "sinceYear" : self.sinceYear,
            "freelance": self.canFreelance,
            "relatedOrganizationLites" : (relatetedOrgs == nil || relatetedOrgs!.isEmpty) ? NSNull() : relatetedOrgs!
        ]
    }
}


//=============
// DJProfile
//=============

protocol DJProfileType {
    
    var bio : String { get set }
    var danceTypes : [IDanceType] { get set }
    var sinceYear : Int { get set }
    var canFreelance : Bool { get set }
    var relatedOrganizations : [OrganizationLiteType]? { get set }
    
}

struct DJProfile : DJProfileType {
    
    var bio: String = ""
    var danceTypes = [IDanceType]()
    var sinceYear: Int = 0
    var canFreelance: Bool = false
    var relatedOrganizations : [OrganizationLiteType]?
}

extension DJProfile {
    
    init?(json:[String:Any]) {
        
        guard let dances = json["selectedDanceTypes"] as? [[String:Any]] else {
            return nil
        }
        
        for dancObj in dances {
            self.danceTypes.append(DanceType(json: dancObj)!)
        }
        
        if let bio = json["djBio"] as? String {
            self.bio = bio
        }
        
        if let since = json["sinceYear"] as? Int {
            self.sinceYear = since
        }
        
        if let isFreelance = json["freelance"] as? Bool {
            self.canFreelance = isFreelance
        }
        
        if let relatedOrgs = json["relatedOrganizationLites"] as? [[String:Any]] {
            
            self.relatedOrganizations = [OrganizationLite]()
            
            for org in relatedOrgs {
                self.relatedOrganizations?.append(OrganizationLite(json: org)!)
            }
        }
    }
}

extension DJProfile : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        // Dances
        var dances : [[String:Any]]?
        for dance in self.danceTypes {
            
            dances = [[String:Any]]()
            dances?.reserveCapacity(self.danceTypes.count)
            
            if let danceObj = dance as? DanceType {
                dances?.append(danceObj.jsonData)
            }
        }
        
        // Organizations
        var relatetedOrgs : [[String:Any]]?
        if let relatedOrganizations = self.relatedOrganizations {
            
            relatetedOrgs = [[String:Any]]()
            relatetedOrgs?.reserveCapacity(relatedOrganizations.count)
            
            for org in relatedOrganizations {
                if let orgLite = org as? OrganizationLite {
                    relatetedOrgs?.append(orgLite.jsonData)
                }
            }
        }
        
        return [
            "djBio" : self.bio,
            "selectedDanceTypes" : (dances == nil || dances!.isEmpty) ? NSNull() : dances!,
            "sinceYear" : self.sinceYear,
            "freelance": self.canFreelance,
            "relatedOrganizationLites" : (relatetedOrgs == nil || relatetedOrgs!.isEmpty) ? NSNull() : relatetedOrgs!
        ]
    }
}


//=============
// UserProfile
//=============

protocol UserModelType {
    
    var userId : String { get set }
    var userName : String { get set }
    var fullName : String { get set }
    var email : String { get set }
    
    var isPrivateAccount : Bool { get set }
    
    var followerCounter : Int? { get set }
    var followingCounter : Int? { get set }
    var postsCounter : Int? { get set }
    
    var profilePhoto : ImageType? { get set }
    var bio : String? { get set }
    var websiteUrl : String? { get set }
    
    var danceTypes : [IDanceType]? { get set }
    
    var djProfile : DJProfileType? { get set }
    var instructorProfile : InstructorProfileType? { get set }
}


struct UserModel : UserModelType{
    // User model can only be parsed from API requests for an existing user.
    // So, it should have id, username, fullname, email informations
    
    var userId : String
    var userName : String
    var fullName : String
    var email : String
    
    var isPrivateAccount : Bool = false
    
    var followerCounter : Int?
    var followingCounter : Int?
    var postsCounter : Int?
    
    var profilePhoto : ImageType?
    var bio : String?
    var websiteUrl : String?
    
    var danceTypes : [IDanceType]?
    
    var djProfile : DJProfileType?
    var instructorProfile : InstructorProfileType?
    
}

extension UserModel {
    
    init?(json:[String:Any]) {
        
        guard let userID = json["userId"] as? String, let userName = json["username"] as? String,
            let fullName = json["fullname"] as? String, let email = json["email"] as? String else {
                
                return nil
        }
        
        
        self.userId = userID
        self.userName = userName
        self.fullName = fullName
        self.email = email
        
        if let accountPrivacy = json["privateAccount"] as? Bool {
            self.isPrivateAccount = accountPrivacy
        }
        
        if let followers = json["followers"] as? Int {
            self.followerCounter = followers
        }
        
        if let followings = json["followings"] as? Int {
            self.followingCounter = followings
        }
        
        if let posts = json["posts"] as? Int{
            self.postsCounter = posts
        }
        
        if let photo = json["profilePhoto"] as? [String:Any], let isImage = photo["image"] as? Bool, isImage == true {
            self.profilePhoto = MediaImage(json: photo)
        }
        
        if let bio = json["bio"] as? String {
            self.bio = bio
        }
        
        if let webUrl = json["website"] as? String {
            self.websiteUrl = webUrl
        }
        
        if let danceTypes = json["selectedDanceTypes"] as? [[String:Any]], !danceTypes.isEmpty {
            
            self.danceTypes = [DanceType]()
            self.danceTypes!.reserveCapacity(danceTypes.count)
            for danceObj in danceTypes {
                self.danceTypes?.append(DanceType(json: danceObj)!)
            }
        }
        
        if let dj = json["djProfile"] as? [String:Any] {
            self.djProfile = DJProfile(json: dj)
        }
        
        if let instructor = json["instructorProfile"] as? [String:Any] {
            self.instructorProfile = InstructorProfile(json: instructor)
        }
    }
}
