//
//  UserListModel.swift
//  OneDance
//
//  Created by Burak Can on 3/17/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// ============
// MODEL
// ============

protocol PageableUserListModelType: UserListModelType, PageableModel { }

struct UserListModel: PageableUserListModelType{
    
    var items : [UserLiteType] = [UserLite]()
    var nextPageKey: String = ""
    
    
    init?(json:[String:Any]){
        
        if let users = json["users"] as? [[String:Any]], !users.isEmpty{
            for user in users{
                if let userObj = UserLite(json: user){
                    self.items.append(userObj)
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
