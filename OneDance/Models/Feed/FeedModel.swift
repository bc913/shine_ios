//
//  FeedModel.swift
//  OneDance
//
//  Created by Burak Can on 3/17/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

//==================
// Feed Item
//==================

struct Feed {
    var post : PostDetailType = PostDetail()
    init() {
    }
    
    init(postDetail: PostDetailType) {
        self.post = postDetail
    }
    
    init?(json:[String:Any]) {
        guard let postDetail = json["post"] as? [String:Any] else { return nil }
        self.post = PostDetail(json: postDetail)!
    }
    
    // Convenience properties
    var username : String {
        get{
            return self.post.owner?.userName ?? "Undefined"
        }
    }
    
    var date : Date {
        get{
            return self.post.dateCreated ?? Date()
        }
    }
    
    var text : String {
        get {
            return self.post.text
        }
    }
    
    var profilePhotoUrl : String {
        get{
            
            let url = self.post.owner?.profilePhoto?.thumbnail?.url?.absoluteString
            return url ?? ""
        }
    }
    
    var locationName : String {
        get{
            return self.post.location?.name ?? ""
        }
    }
    
    var location : LocationLite?{
        get{
            return self.post.location as? LocationLite
        }
    }
    
    var hasPostMedia : Bool {
        get{
            
            return self.post.media != nil && self.post.media!.id != nil && self.post.media!.id!.isEmpty
        }
    }
    
    var postMediaUrl : String {
        get{
            let url = self.post.media?.standard?.url?.absoluteString
            return url ?? ""
        }
    }
    
    var id : String {
        get{
            return self.post.id
        }
        
    }
    
    var commentCounter : Int {
        get{
            return self.post.commentCounter
        }
    }
    
    var likeCounter : Int {
        get {
            return self.post.likeCounter
        }
    }
    
    var ownerId : String{
        get {
            return self.post.owner?.userId ?? self.post.organization?.id ?? ""
        }
    }
    
}

extension Feed : JSONDecodable {
    var jsonData : [String:Any] {
        
        let postDetail = self.post as? JSONDecodable
        
        /// TODO: Update this code
        let dummyDate = Date()
        
        return [
            "post": postDetail?.jsonData ?? [String:Any](),
            "date": Int(((dummyDate.timeIntervalSince1970) * 1000).rounded()),
            "feedType": "dummy",
            "event": [String:Any](),
            "originatorUser": [String:Any](),
            "originatorOrganization" : [String:Any](),
            "comment": "No Comment"
        ]
    }
}

struct FeedListModel {
    
    var feedItems = [Feed]()
    var nextPageKey : String = ""
    
    init() {
        
    }
    
    init?(json:[String:Any]) {
        
        if let feeds = json["feedItems"] as? [[String:Any]], !feeds.isEmpty {
            for feed in feeds {
                self.feedItems.append(Feed(json:feed)!)
            }
        }
        
        if let key = json["nextPageKey"] as? String {
            self.nextPageKey = key
        }
    }
}
