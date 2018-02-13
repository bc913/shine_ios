//
//  EventBase.swift
//  OneDance
//
//  Created by Burak Can on 12/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


//============
// MARK: AttendeeType
//============

protocol AttendeesQuantityType {
    var going : Int { get set }
    var notGoing : Int { get set }
    var interested : Int { get set }
}

struct AttendeesQuantity : AttendeesQuantityType {
    var going: Int = 0
    var notGoing: Int = 0
    var interested: Int = 0
}

extension AttendeesQuantity {
    init? (json:[String:Any]) {
        if let goings = json["going"] as? Int {
            self.going = goings
        }
        
        if let notGoings = json["notGoing"] as? Int {
            self.notGoing = notGoings
        }
        
        if let interesteds = json["interested"] as? Int {
            self.interested = interesteds
        }
    }
}

extension AttendeesQuantity : JSONDecodable {
    var jsonData : [String : Any] {
        return [
            "going" : self.going,
            "notGoing" : self.notGoing,
            "interested":self.interested
        ]
    }
}

//============
// MARK: Event Contact Person
// ============

protocol ContactPersonType {
    
    var name : String? { get set }
    var email : String? { get set }
    var phone : String? { get set }
}

struct ContactPerson : ContactPersonType {
    
    var name : String?
    var email : String?
    var phone : String?
    
    init() { }
    
}

extension ContactPerson {
    
    init?(json:[String:Any]) {
        
        guard let name = json["name"] as? String, let email = json["email"] as? String, let phone = json["phone"] as? String else { return nil }
        
        self.name = name
        self.email = email
        self.phone = phone
    }
}

extension ContactPerson : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "name" : self.name ?? "",
            "email" : self.name ?? "",
            "phone" : self.phone ?? ""
        ]
    }
}

//============
// MARK: Event Policy
//============

protocol EventPolicyType {
    
    var dressCode : Bool { get set }
    var partnerRequired : Bool { get set }
    var other : String? { get set }
}

struct EventPolicy : EventPolicyType{
    
    var dressCode : Bool = false
    var partnerRequired : Bool = false
    var other : String?
    
    init() {}
    
    
}

extension EventPolicy {
    
    init?(json: [String:Any]) {
        
        if let hasDressCode = json["dressCode"] as? Bool {
            self.dressCode = hasDressCode
        }
        
        if let isPartnerRequired = json["partnerRequired"] as? Bool {
            self.partnerRequired = isPartnerRequired
        }
        
        if let otherDesc = json["other"] as? String {
            self.other = otherDesc
        }
        
    }
}

extension EventPolicy : JSONDecodable {
    
    var jsonData : [String:Any] {
        return [
            "dressCode" : self.dressCode,
            "partnerRequired" : self.partnerRequired,
            "other" : self.other ?? ""
        ]
    }
    
}



//============
// MARK: Event Lite
//============

protocol EventLiteType {
    var id : String { get set }
    var title : String { get set }
    var startDate : Date { get set }
    var endDate : Date { get set }
    var location : LocationLiteType { get set }
    var photo : ImageType? { get set }
    var danceTypes : [IDanceType] { get set }
    var attendees : AttendeesQuantityType? { get set }
    var eventType : EventType? { get set }
}

struct EventLite : EventLiteType {
    var id : String = ""
    var title: String = ""
    var startDate: Date
    var endDate: Date
    
    var location: LocationLiteType
    var photo: ImageType?
    var danceTypes: [IDanceType]
    var attendees: AttendeesQuantityType?
    var eventType: EventType?
    
    init(id: String, title: String, start: Date, end: Date, location: LocationLiteType, dances: [IDanceType], type: EventType) {
        self.id = id
        self.title = title
        self.startDate = start
        self.endDate = end
        self.location = location
        self.danceTypes = dances
        self.eventType = type
    }
    
    
}

extension EventLite {
    
    init?(json:[String:Any]) {
        
        guard let id = json["id"] as? String, let title = json["title"] as? String,
        let startUnixTime = json["start"] as? Int, let endUnixTime = json["end"] as? Int,
        let location = json["location"] as? [String:Any], let dances = json["danceTypes"] as? [[String:Any]]
            else { return nil }
        
        self.id = id
        self.title = title
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startUnixTime / 1000))
        self.endDate = Date(timeIntervalSince1970: TimeInterval(endUnixTime / 1000))
        self.location = LocationLite(json: location)!
        
        if let coverPhoto = json["photo"] as? [String:Any] {
            self.photo = MediaImage(json: coverPhoto)
        }
        
        self.danceTypes = [DanceType]()
        for danceObj in dances {
            self.danceTypes.append(DanceType(json: danceObj)!)
        }
        
        
        if let attendees = json["attendees"] as? [String:Any] {
            self.attendees = AttendeesQuantity(json:attendees)
        }
        
        if let eventType = json["type"] as? String {
            self.eventType = EventType(rawValue: eventType)!
        }
        
    }
}

extension EventLite : JSONDecodable {
    var jsonData : [String:Any] {
        
        // Dances
        var dances : [[String:Any]]?
        for dance in self.danceTypes {
            
            dances = [[String:Any]]()
            dances?.reserveCapacity(self.danceTypes.count)
            
            if let danceObj = dance as? DanceType {
                dances?.append(danceObj.jsonData)
            }
        }
        
        let loc = self.location as? JSONDecodable
        let eventPhoto = self.photo as? JSONDecodable
        let attendeesInfo = self.attendees as? JSONDecodable
        
        return [
            "id" : self.id,
            "title": self.title,
            "start": self.startDate.timeIntervalSince1970 * 1000,
            "end" : self.endDate.timeIntervalSince1970 * 1000,
            "location" : loc?.jsonData ?? [String:Any](),
            "photo" : eventPhoto ?? [String:Any](),
            "danceTypes" : (dances == nil || dances!.isEmpty) ? [[String:Any]]() : dances!,
            "attendees" : attendeesInfo?.jsonData ?? [String:Any](),
            "type" : self.eventType?.rawValue ?? ""
        ]
    }
}

//============
// Event Type
//============
enum EventType : String {
    case _class = "Class"
    case _workshop = "Workshop"
    case _party = "Party"
    case _festival = "Festival"
    case _other = "Other"

    
    static func allCases() -> Array<String> {
        
        var cases = Array<String>()
        
        cases.append(EventType._class.rawValue)
        cases.append(EventType._workshop.rawValue)
        cases.append(EventType._party.rawValue)
        cases.append(EventType._festival.rawValue)
        cases.append(EventType._other.rawValue)        
        
        return cases
    }
}


//============
// MARK: Event
//============
struct EventModel {
    
    var id : String?
    var title : String = ""//required
    var description : String = "" // required
    
    var ownerUser : UserLiteType?
    var ownerOrganization : OrganizationLiteType?
    
    var danceTypes : [IDanceType]? // required
    var webUrl : URL?
    
    var location : LocationLiteType? // required
    var contact : ContactPersonType?
    
    var coverPhoto : ImageType?
    
    var attendees : AttendeesQuantityType?
    var startingTime : Date? // required
    var endTime : Date? // required
    var duration : String?
    
    var level : DanceLevel?    
    var type : EventType? // required
    
    var instructors : [UserLiteType]?
    var djs : [UserLiteType]?
    
    var policy : EventPolicyType? //required
    var hasWorkshop : Bool = false
    var hasPerformance : Bool = false
    
    var fee : FeePolicyType? // required
    
    init() {
        
    }
    
    init?(json: [String:Any]) {
        
        guard let id = json["id"] as? String, let title = json["title"] as? String,
            let desc = json["desc"] as? String else {
                
                print("EventModel failed")
                print("id: \(String(describing: json["id"] as? String))")
                
                
                return nil
        }
        
        self.id = id
        self.title = title
        self.description = desc
        if let location = json["location"] as? [String:Any] {
            self.location = LocationLite(json: location)!
        }
        
        
        if let owner = json["ownerUser"] as? [String:Any] {
            self.ownerUser = UserLite(json: owner)
        }
        
        if let ownerOrg = json["ownerOrganization"] as? [String:Any] {
            self.ownerOrganization = OrganizationLite(json: ownerOrg)
        }
        
        if let danceTypes = json["danceTypes"] as? [[String:Any]] {
            self.danceTypes = [DanceType]()
            self.danceTypes!.reserveCapacity(danceTypes.count)
            for danceObj in danceTypes {
                self.danceTypes?.append(DanceType(json: danceObj)!)
            }
            
        }
        
        if let url = json["url"] as? String {
            self.webUrl = URL(string: url)
        }
        
        if let contactPerson = json["contactPerson"] as? [String:Any] {
            self.contact = ContactPerson(json: contactPerson)
        }
        
        if let coverPhoto = json["photo"] as? [String:Any], let isImage = coverPhoto["image"] as? Bool, isImage == true {
            self.coverPhoto = MediaImage(json: coverPhoto)
        }
        
        if let attendees = json["attendees"] as? [String:Any] {
            self.attendees = AttendeesQuantity(json:attendees)
        }
        
        if let startUnixTime = json["start"] as? Int{
            self.startingTime = Date(timeIntervalSince1970: TimeInterval(startUnixTime / 1000))
        }
        
        if let endUnixTime = json["end"] as? Int {
            self.endTime = Date(timeIntervalSince1970: TimeInterval(endUnixTime / 1000))
        }
        
        if let duration = json["duration"] as? String {
            self.duration = duration
        }
        
        if let danceLevel = json["level"] as? String {
            self.level = DanceLevel(rawValue: danceLevel)
        }
        
        if let eventType = json["type"] as? String {
            self.type = EventType(rawValue: eventType)
        }
        
        if let instructorList = json["instructors"] as? [[String:Any]], !(instructorList.isEmpty) {
            
            self.instructors = [UserLite]()
            for instructor in instructorList {
                self.instructors?.append(UserLite(json: instructor)!)
            }
        }
        
        if let djList = json["djs"] as? [[String:Any]], !(djList.isEmpty) {
            self.djs = [UserLite]()
            for dj in djList {
                self.djs?.append(UserLite(json: dj)!)
            }
        }
        
        if let eventPolicy = json["policy"] as? [String:Any] {
            self.policy = EventPolicy(json: eventPolicy)
        }
        
        if let hasWorkShop = json["hasWorkshop"] as? Bool {
            self.hasWorkshop = hasWorkShop
        }
        
        if let hasPerformance = json["hasPerformance"] as? Bool {
            self.hasPerformance = hasPerformance
        }
        
        if let feePolicy = json["fee"] as? [String:Any] {
            self.fee = FeePolicy(json: feePolicy)
        }
        
    }
}

extension EventModel : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        let userOwner = self.ownerUser as? JSONDecodable
        let organizationOwner = self.ownerOrganization as? JSONDecodable
        
        var dances : [[String:Any]]?
        if let danceTypeItems = self.danceTypes, !(danceTypeItems.isEmpty) {
            
            dances = [[String:Any]]()
            dances?.reserveCapacity(danceTypeItems.count)
            
            for dance in danceTypeItems {
                
                if let danceObj = dance as? DanceType {
                    dances?.append(danceObj.jsonData)
                }
            }
        }
        
        let loc = self.location as? JSONDecodable
        let contact = self.contact as? JSONDecodable
        let photo = self.coverPhoto as? JSONDecodable
        let attendeesQuantity = self.attendees as? JSONDecodable
        
        // Instructors
        var instList : [[String:Any]]?
        if let instructors = self.instructors, !(instructors.isEmpty){
            
            instList = [[String:Any]]()
            instList?.reserveCapacity(instructors.count)
            
            for inst in instructors {
                if let instObj = inst as? UserLite {
                    instList?.append(instObj.jsonData)
                }
            }
            
        }
        
        // DJS
        var djList : [[String:Any]]?
        if let djs = self.djs, !(djs.isEmpty){
            
            djList = [[String:Any]]()
            djList?.reserveCapacity(djs.count)
            
            for dj in djs {
                if let djObj = dj as? UserLite {
                    djList?.append(djObj.jsonData)
                }
            }
        }

        
        let eventPolicy = self.policy as? JSONDecodable
        let feePolicy = self.fee as? JSONDecodable
        
        return [
            "id": self.id ?? "",
            "title": self.title,
            "desc" : self.description,
            "ownerUser" : userOwner?.jsonData ?? [String:Any](),
            "ownerOrganization" : organizationOwner?.jsonData ?? [String:Any](),
            "danceTypes" : (dances == nil || dances!.isEmpty) ? [[String:Any]]() : dances!,
            "url" : self.webUrl?.path ?? "",
            "location" : loc?.jsonData ?? [String:Any](),
            "contactPerson" : contact?.jsonData ?? [String:Any](),
            "photo" : photo?.jsonData ?? [String:Any](),
            "attendees" : attendeesQuantity?.jsonData ?? [String:Any](),
            "start" : self.startingTime != nil ? Int(((self.startingTime?.timeIntervalSince1970)! * 1000).rounded()) : 0,
            "end" : self.endTime != nil ? Int(((self.endTime?.timeIntervalSince1970)! * 1000).rounded()) : 0,
            "duration": self.duration ?? "",
            "level" : self.level?.rawValue ?? "",
            "type" : self.type?.rawValue ?? "",
            "instructors" : (instList == nil || instList!.isEmpty) ? [[String:Any]]() : instList!,
            "djs":(djList == nil || djList!.isEmpty) ? [[String:Any]]() : djList!,
            "policy" : eventPolicy?.jsonData ?? [String:Any](),
            "hasWorkshop":self.hasWorkshop,
            "hasPerformance" : self.hasPerformance,
            "fee" : feePolicy?.jsonData ?? [String:Any]()
        ]
    }
}
