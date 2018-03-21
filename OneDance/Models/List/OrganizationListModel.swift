//
//  OrganizationListModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation


protocol PageableOrganizationListModelType : PageableModel,  OrganizationListModelType{}

struct OrganizationListModel : PageableOrganizationListModelType {
    
    var items : [OrganizationLite] = [OrganizationLite]()
    var nextPageKey : String = ""
    
    init() {
        
    }
    
    init?(json:[String:Any]){
        
        if let orgs = json["organizations"] as? [[String:Any]], !orgs.isEmpty {
            
            for org in orgs {
                if let orgObject = OrganizationLite(json: org) {
                    self.items.append(orgObject)
                }
            }
            
        } else { return nil }
        
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
