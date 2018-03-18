//
//  PostModel.swift
//  OneDance
//
//  Created by Burak Can on 3/17/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

//==================
// Post Detail
//==================

protocol PostDetailType {
    var id : String { get set }
    var repostedPostId : String { get set }
    
    var text : String { get set }
    
    var media : ImageType? { get set }
    
    var owner : UserLiteType? { get set }
    var location : LocationLiteType? { get set }
    var organization : OrganizationLiteType? { get set }
    
    var likeCounter : Int { get set }
    var commentCounter : Int { get set }
    
    var dateCreated : Date? { get set }
}

struct PostDetail : PostDetailType{
    var id : String = ""
    var repostedPostId : String = ""
    
    /// Post description
    var text : String = ""
    
    var media : ImageType?
    
    var owner : UserLiteType?
    var location : LocationLiteType?
    var organization : OrganizationLiteType?
    
    var likeCounter : Int = 0
    var commentCounter : Int = 0
    
    var dateCreated : Date?
    
    init() { }
    
    init?(json: [String:Any]){
        
        guard let id = json["id"] as? String else {
            assert(true, "Post detail initialization failed")
            return nil
        }
        
        self.id = id
        
        if let repostId = json["repostedPostId"] as? String {
            self.repostedPostId = repostId
        }
        
        if let postText = json["text"] as? String{
            self.text = postText
        }
        
        if let media = json["media"] as? [String:Any], let isImage = media["image"] as? Bool, isImage == true {
            self.media = MediaImage(json: media)
        }
        
        if let owner = json["owner"] as? [String:Any] {
            self.owner = UserLite(json: owner)
        }
        
        if let location = json["location"] as? [String:Any] {
            self.location = LocationLite(json: location)!
        }
        
        if let ownerAsOrg = json["organization"] as? [String:Any] {
            self.organization = OrganizationLite(json: ownerAsOrg)
        }
        
        if let likes = json["likes"] as? Int {
            self.likeCounter = likes
        }
        
        if let comments = json["comments"] as? Int {
            self.commentCounter = comments
        }
        
        if let createdUnixTime = json["created"] as? Int {
            self.dateCreated = Date(timeIntervalSince1970: TimeInterval(createdUnixTime / 1000))
        }
    }
    
    
}

extension PostDetail : JSONDecodable {
    
    var jsonData : [String:Any]{
        
        let mediaInfo = self.media as? JSONDecodable
        let loc = self.location as? JSONDecodable
        let userOwner = self.owner as? JSONDecodable
        let organizationOwner = self.organization as? JSONDecodable
        
        return[
            "id": self.id,
            "repostedPostId": self.repostedPostId,
            "text": self.text,
            "media": mediaInfo?.jsonData ?? [String:Any](),
            "owner": userOwner?.jsonData ?? [String:Any](),
            "location": loc?.jsonData ?? [String:Any](),
            "organization": organizationOwner?.jsonData ?? [String:Any](),
            "likes": self.likeCounter,
            "comments": self.commentCounter,
            "created": self.dateCreated != nil ? Int(((self.dateCreated!.timeIntervalSince1970) * 1000).rounded()) : 0,
        ]
        
    }
    
}
