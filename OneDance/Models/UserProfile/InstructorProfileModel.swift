//
//  InstructorProfileModel.swift
//  OneDance
//
//  Created by Burak Can on 11/3/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol InstructorProfileModelType {
    
    var yearsOfExperience : Int { get set }
    var danceTypes : Array<IDanceType> { get set }
    

}


struct InstructorProfileModel : InstructorProfileModelType {
    var yearsOfExperience: Int
    var danceTypes = Array<IDanceType>()
    
    init(years: Int, dances: Array<IDanceType>) {
        self.yearsOfExperience = years
        self.danceTypes = dances
    }
}

extension InstructorProfileModel {
    
    init?(json:[String:Any]){
        
        if let yearsOfExp = json["yearsOfExperience"] as? String,
            let dances = json["danceTypes"] as? [[String:Any]] {
            
            self.yearsOfExperience = Int(yearsOfExp) ?? 0
            for danceObj in dances {
                self.danceTypes.append(DanceType(json: danceObj)!)
            }
            
        } else {
            return nil
        }
        
        
        
    }
}
