//
//  EventListModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

protocol PageableEventListModelType : PageableModel, EventListModelType {}

struct EventListModel : PageableEventListModelType {
    
    var items: [EventLiteType] = [EventLite]()
    var nextPageKey: String = ""
    
    init() {
        
    }
    
    init?(json:[String:Any]) {
        if let events = json["events"] as? [[String:Any]], !events.isEmpty {
            for event in events {
                if let eventObj = EventLite(json: event) {
                    self.items.append(eventObj)
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
