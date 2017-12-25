//
//  Organization.swift
//  OneDance
//
//  Created by Burak Can on 12/3/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

//=============
// OrganizationContact
//=============

protocol ContactInfoType {
    
    var email : String? { get set }
    var phone : String? { get set }
    var website : URL? { get set }
    
    var instagramUrl : URL? { get set }
    var facebookUrl : URL? { get set }
    var locations : [LocationLiteType]? { get set }
}

struct ContactInfo : ContactInfoType {
    
    var email : String?
    var phone : String?
    var website : URL?
    
    var instagramUrl : URL?
    var facebookUrl : URL?
    var locations : [LocationLiteType]?
    
    init() { }
    
    
}

extension ContactInfo {
    
    init?(json:[String:Any]) {
        
        guard let email = json["email"] as? String else {
            return nil
        }
        
        self.email = email
        
        if let phoneNumber = json["phone"] as? String {
            self.phone = phoneNumber
        }
        
        if let url = json["website"] as? String {
            self.website = URL(string: url)
        }
        
        if let faceUrl = json["facebookUrl"] as? String {
            self.facebookUrl = URL(string: faceUrl)
        }
        
        if let instUrl = json["instagramUrl"] as? String {
            self.instagramUrl = URL(string: instUrl)
        }
        
        if let locationList = json["locations"] as? [[String:Any]], !(locationList.isEmpty) {
            
            self.locations = [LocationLite]()
            
            for locObj in locationList {
                self.locations?.append(LocationLite(json: locObj)!)
            }
            
        }
        
    }
    
}

extension ContactInfo : JSONDecodable {
    
    var jsonData: [String : Any] {
        
        var locs : [[String:Any]]?
        if let selfLocs = self.locations, !(selfLocs.isEmpty) {
            
            locs = [[String:Any]]()
            locs?.reserveCapacity(selfLocs.count)
            
            for loc in selfLocs {
                if let locObj = loc as? LocationLite {
                    locs?.append(locObj.jsonData)
                }
            }
        }
        
        
        return [
            "email" : self.email ?? "",
            "phone" : self.phone ?? "",
            "website" : self.website?.absoluteString ?? "",
            "instagramUrl" : self.instagramUrl?.absoluteString ?? "",
            "facebookUrl" : self.facebookUrl?.absoluteString ?? "",
            "locations" : (locs == nil || locs!.isEmpty) ? NSNull() : locs!
        ]
    }
}

//=============
// OrganizationLite
//=============

protocol OrganizationLiteType {
    
    var id : String? { get set }
    var name : String? { get set }
    
    var photo : ImageType? { get set }
    var followerCounter : Int? { get set }
    var location : LocationLiteType? { get set }
}

struct OrganizationLite : OrganizationLiteType {
    
    var id: String?
    var name: String?
    var location: LocationLiteType?
    
    var followerCounter: Int?
    
    var photo: ImageType?
    
    
    init() { }
    
}

extension OrganizationLite {
    
    init?(json: [String:Any]) {
        
        guard let id = json["id"] as? String, let name = json["name"] as? String,
            let locationInfo = json["location"] as? [String:Any]  else { return nil }
        
        
        self.id = id
        self.name = name
        self.location = LocationLite(json: locationInfo)
        
        if let photo = json["photo"] as? [String:Any] {
            self.photo = MediaImage(json: photo)
        }
        
        if let followerQuantity = json["followers"] as? Int {
            self.followerCounter = followerQuantity
        }
        
    }
}

extension OrganizationLite : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        let photo = self.photo as? MediaImage
        let loc = self.location as? LocationLite
        
        return [
            "id" : self.id ?? "",
            "name" : self.name ?? "",
            "photo" : photo?.jsonData ?? NSNull(),
            "location" :loc?.jsonData ?? NSNull(),
            "followers" : self.followerCounter ?? 0
        ]
    }
}

//=============
// Organization
//=============

protocol OrganizationType {
    
    var id : String? { get set }
    var name : String? { get set } // required
    var about :String? { get set } // required
    
    var danceTypes : [IDanceType]? { get set } // required
    
    var contact : ContactInfoType? { get set } // required
    
    var photo : ImageType? { get set }
    var instructors : [UserLiteType]? { get set }
    var djs : [UserLiteType]? { get set }
    
    var hasClassForKids : Bool { get set }
    var hasPrivateClass : Bool { get set }
    var hasWeddingPackage : Bool { get set }
    
    var followerCounter : Int? { get set }
    var postsCounter : Int? { get set }
}

struct Organization : OrganizationType{
    
    var id : String?
    var name : String?
    var about :String?
    
    var danceTypes : [IDanceType]?
    
    var contact : ContactInfoType?
    
    var photo : ImageType?
    var instructors : [UserLiteType]?
    var djs : [UserLiteType]?
    
    var hasClassForKids : Bool = false
    var hasPrivateClass : Bool = false
    var hasWeddingPackage : Bool = false
    
    var followerCounter : Int?
    var postsCounter : Int?
    
    
    init() { }
    
}

extension Organization {
    
    init?(json: [String:Any]){
        
        if let id = json["id"] as? String {
            self.id = id
        }
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let about = json["about"] as? String {
            self.about = about
        }
        
        if let danceTypes = json["danceTypes"] as? [[String:Any]] {
            self.danceTypes = [DanceType]()
            self.danceTypes!.reserveCapacity(danceTypes.count)
            for danceObj in danceTypes {
                self.danceTypes?.append(DanceType(json: danceObj)!)
            }
            
        }
        
        if let contact = json["contactInfo"] as? [String:Any] {
            self.contact = ContactInfo(json: contact)
        }
        
        if let photo = json["photo"] as? [String:Any], let isImage = photo["image"] as? Bool, isImage == true {
            self.photo = MediaImage(json: photo)
        }
        
        if let instructorList = json["instructors"] as? [[String:Any]], !instructorList.isEmpty {
            self.instructors = [UserLite]()
            
            for instructor in instructorList {
                self.instructors?.append(UserLite(json: instructor)!)
            }
        }
        
        if let djList = json["djs"] as? [[String:Any]], !(djList.isEmpty) {
            self.djs = [UserLite]()
            for dj in djList {
                self.djs?.append(UserLite(json: dj)!)
            }
        }
        
        if let classForKids = json["hasClassForKids"] as? Bool {
            self.hasClassForKids = classForKids
        }
        
        if let privateClass = json["hasPrivateClass"] as? Bool {
            self.hasPrivateClass = privateClass
        }
        
        if let weddingPackage = json["hasWeddingPackage"] as? Bool {
            self.hasWeddingPackage = weddingPackage
        }
        
        if let followers = json["followers"] as? Int {
            self.followerCounter = followers
        }
        
        if let posts = json["posts"] as? Int {
            self.postsCounter = posts
        }
        
    }
}

extension Organization : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        var dances : [[String:Any]]?
        if let danceTypeItems = self.danceTypes, !(danceTypeItems.isEmpty) {
            
            dances = [[String:Any]]()
            dances?.reserveCapacity(danceTypeItems.count)
            
            for dance in danceTypeItems {
                
                if let danceObj = dance as? DanceType {
                    dances?.append(danceObj.jsonData)
                }
            }
        }
        
        let contactInfo = self.contact as? JSONDecodable
        let profilePhoto = self.photo as? MediaImage
        
        // Instructors
        var instList : [[String:Any]]?
        if let instructors = self.instructors, !(instructors.isEmpty){
            
            instList = [[String:Any]]()
            instList?.reserveCapacity(instructors.count)
            
            for inst in instructors {
                if let instObj = inst as? UserLite {
                    instList?.append(instObj.jsonData)
                }
            }
            
        }
        
        // DJS
        var djList : [[String:Any]]?
        if let djs = self.djs, !(djs.isEmpty){
            
            djList = [[String:Any]]()
            djList?.reserveCapacity(djs.count)
            
            for dj in djs {
                if let djObj = dj as? UserLite {
                    djList?.append(djObj.jsonData)
                }
            }
        }
        
        return [
            "id" : self.id ?? "",
            "name" : self.name ?? "",
            "about" : self.about ?? "",
            "danceTypes": (dances == nil || dances!.isEmpty) ? NSNull() : dances!,
            "contactInfo": contactInfo?.jsonData ?? NSNull(),
            "photo" : profilePhoto?.jsonData ?? NSNull(),
            "instructors" : (instList == nil || instList!.isEmpty) ? NSNull() : instList!,
            "djs": (djList == nil || djList!.isEmpty) ? NSNull() : djList!,
            "hasClassForKids" : self.hasClassForKids,
            "hasPrivateClass" : self.hasPrivateClass,
            "hasWeddingPackage":self.hasWeddingPackage,
            "followers":self.followerCounter ?? 0,
            "posts" : self.postsCounter ?? 0
        ]
    }
}
