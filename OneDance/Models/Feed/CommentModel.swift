//
//  CommentModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// Model
protocol PostCommentType {
    var id : String { get set }
    var commenter : UserLiteType? { get set }
    var text : String { get set }
    var commentDate : Date { get set }
}

struct PostComment : PostCommentType {
    
    var id : String
    var commenter : UserLiteType?
    var text : String
    var commentDate : Date
    
    
    init() {
        self.id = ""
        self.commenter = UserLite()
        self.text = ""
        self.commentDate = Date()
    }
    
    init(commentId: String, commenter: UserLiteType, text: String, commentDate: Date) {
        self.id = commentId
        self.commenter = commenter
        self.text = text
        self.commentDate = commentDate
    }
}

extension PostComment{
    
    init?(json: [String:Any]) {
        
        guard let commentId = json["id"] as? String, let commentOwner = json["commenter"] as? [String:Any] else {
            
            assertionFailure("Comment with no id")
            return nil
        }
        
        self.id = commentId
        
        if let commentText = json["text"] as? String {
            self.text = commentText
        } else {
            self.text = ""
        }
        
        self.commenter = UserLite(json: commentOwner)
        
        
        if let date = json["commentDate"] as? Int{
            self.commentDate = Date(timeIntervalSince1970: TimeInterval(date / 1000))
        } else {
            self.commentDate = Date()
        }
        
    }
    
}

extension PostComment : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        
        let commenterUser = self.commenter as? JSONDecodable
        
        return [
            "id" : self.id,
            "commenter" : commenterUser?.jsonData ?? [String:Any](),
            "text": self.text,
            "commentDate":Int(((self.commentDate.timeIntervalSince1970) * 1000).rounded())
        ]
    }
}
