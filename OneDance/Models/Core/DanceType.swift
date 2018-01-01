//
//  DanceType.swift
//  OneDance
//
//  Created by Burak Can on 10/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

protocol IDanceType {
    var name : String { get }
    var id : Int { get }
}

struct DanceType : IDanceType {
    var name: String = ""
    var id: Int = 0
    
    init() { }
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
}

extension DanceType {
    
    init?(json:[String:Any]){
        if let danceId = json["id"] as? String, let danceName = json["name"] as? String{
            
            self.id = Int(danceId)!
            self.name = danceName
            
        } else {
            return nil
        }
    }
}

extension DanceType : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "id" : self.id,
            "name": self.name
        ]
    }
}
