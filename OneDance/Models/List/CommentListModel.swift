//
//  CommentListModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

protocol PageableCommentListModelType : PageableModel, CommentListModelType { }

struct CommentListModel : PageableCommentListModelType{
    
    var items : [PostCommentType] = [PostComment]()
    var nextPageKey : String = ""
    
    init() {
        
    }
    
    init?(json:[String:Any]) {
        
        if let comments = json["postComments"] as? [[String:Any]], !comments.isEmpty{
            for comment in comments {
                if let commentObj = PostComment(json: comment) {
                    self.items.append(commentObj)
                }
                
            }
        } else {
            return nil
        }
        
        if let key = json["nextPageKey"] as? String {
            self.nextPageKey = key
        }
        
    }
    
    var count : Int {
        get{
            return self.items.isEmpty ? 0 : self.items.count
        }
    }
}
