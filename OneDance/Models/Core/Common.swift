//
//  Common.swift
//  OneDance
//
//  Created by Burak Can on 12/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol ListableEnum {
    static var allCases : Set<String> { get }
}


//============
// Fee Option
//============

enum FeeType : String {
    
    case free = "Free"
    
    case cover = "Cover" // Single payment event
    case coverDiscounted = "Cover with discount"
    
    case perSession = "per session"
    case perSessionsPackage = "per session package"
    
    case custom = "Custom"
    case undefined = "Undefined"
    
}

extension FeeType : ListableEnum {
    static var allCases : Set<String> {
        return [free.rawValue, cover.rawValue, cover.rawValue, perSession.rawValue, perSessionsPackage.rawValue, custom.rawValue, undefined.rawValue]
    }
}

protocol FeeOptionType {
    var type : FeeType? { get set }
    var value : Double? { get set }
    var numberOfSessions : Int? { get set }
}

struct FeeOption : FeeOptionType {
    
    var type : FeeType?
    var value : Double?
    var numberOfSessions : Int? // Depends on type
    
    init() { }
    init(typeStr: String, feeValue: Double, sessions: Int?) {
        
        var feeType = FeeType(rawValue: typeStr)
        if feeType == nil {
            feeType = FeeType.undefined
        }
        
        self.init(type: feeType!, feeValue: feeValue, sessions: sessions)
    }
    
    init(type: FeeType, feeValue: Double, sessions: Int?) {
        self.type = type
        self.value = feeValue
        self.numberOfSessions = sessions
    }
    
}

extension FeeOption {
    
    init?(json:[String:Any]) {
        
        guard let type = json["type"] as? String,
            let value = json["value"] as? Double,
            let numberOfSessions = json["sessions"] as? Int else { return nil }
        
        self.type = FeeType(rawValue: type)
        if self.type == nil {
            self.type = FeeType.undefined
        }
        
        self.value = value
        self.numberOfSessions = numberOfSessions
        
    }
}

extension FeeOption : Equatable {
    static func == (lhs: FeeOption, rhs: FeeOption) -> Bool {
        return lhs.type == rhs.type
    }
}

extension FeeOption : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "type": self.type?.rawValue ?? "",
            "value" : self.value ?? 0.0,
            "sessions" : self.numberOfSessions ?? 1
        ]
    }
}

//============
// Fee Policy
//============

protocol FeePolicyType {
    //TODO: Make this set and apply equatable protocol
    
    var options : [FeeOptionType]? { get set }
    var description : String? { get set }
    
}


struct FeePolicy : FeePolicyType {
    
    var options : [FeeOptionType]?
    var description : String?
    
    init() { }
    init(options: [FeeOptionType], desc: String = "") {
        self.options = options
        self.description = desc
    }
    
}

extension FeePolicy {
    
    init?(json:[String:Any]) {
       
        if let availableOptions = json["options"] as? [[String:Any]], !availableOptions.isEmpty {
            
            var modelOptions = [FeeOption?]()
            for option in availableOptions {
                modelOptions.append(FeeOption(json: option))
            }
            // Remove nulls
            self.options = modelOptions.flatMap {return $0}
        }
        
        if let desc = json["description"] as? String {
            self.description = desc
        }
    }
    
}


extension FeePolicy : JSONDecodable {
    var jsonData : [String:Any] {
        
        
        var opts : [[String:Any]]?
        
        if let modelOptions = self.options, !(modelOptions.isEmpty) {
            
            opts = [[String:Any]]()
            opts?.reserveCapacity(modelOptions.count)
            
            for option in modelOptions {
                if let optObj = option as? JSONDecodable{
                    opts!.append(optObj.jsonData)
                }
                
            }
            
        }
        
        return [
            "options" : (opts == nil || opts!.isEmpty) ? [[String:Any]]() : opts!,
            "description" : self.description ?? ""
        ]
    }
}

//============
// Level
//============

enum DanceLevel : String {
    case beginner = "Beginner"
    case advBeginner = "Advanced Beginner"
    case intermediate = "Intermediate"
    case upperIntermediate = "Upper Intermediate"
    case advanced = "Advanced"
    case pro = "Pro"
    case performance = " Performance"
    case competition = "Competition"
    case allLevels = "Open to all levels"
    case other = "Other"
    case custom
}
