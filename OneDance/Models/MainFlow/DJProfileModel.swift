//
//  DJProfileModel.swift
//  OneDance
//
//  Created by Burak Can on 11/3/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol DJProfileModelType {
    
    var sinceYear : Int { get set }
    var danceTypes : Array<IDanceType> { get set }
    var freelance : Bool { get set }
    
    
}


struct DJProfileModel : DJProfileModelType {
    
    var sinceYear: Int
    var danceTypes = Array<IDanceType>()
    var freelance: Bool
    
    init(sinceYear: Int, dances: Array<IDanceType>, isFreelance: Bool) {
        self.sinceYear = sinceYear
        self.danceTypes = dances
        self.freelance = isFreelance
    }
}

extension DJProfileModel {
    
    init?(json:[String:Any]){
        
        if let sinceYear = json["sinceYear"] as? Int, let freelance = json["freelance"] as? Bool,
            let dances = json["danceTypes"] as? [[String:Any]] {
            
            self.sinceYear = sinceYear
            self.freelance = freelance
            for danceObj in dances {
                self.danceTypes.append(DanceType(json: danceObj)!)
            }
            
        } else {
            return nil
        }
        
        
        
    }
}
