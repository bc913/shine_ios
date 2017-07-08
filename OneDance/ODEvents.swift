//
//  ODEvents.swift
//  OneDance
//
//  Created by Burak Can on 7/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class ODEvent: Event {
    var name: String = ""
    var description: String = ""
    var webUrl: String = ""
    var discussion = Array<String>()
    
    var location: String = ""
    var schedule: String = ""
    
    var organizer: OrganizationProfile? = nil
    
    var likeCounter: Int?
    var interestedDancers: Array<DancerProfile> = []
    
    var imageUrls: Array<String> = []
    var videoUrls: Array<String> = []
    
    //ctors
    
    convenience init()
    {
        self.init(eventName:"", eventDescription:"",
                  eventWebUrl:"", eventLocation:"",
                  eventSchedule:"",
                  eventOrganizer:nil )
    }
    
    init(eventName:String, eventDescription:String, eventWebUrl:String,
         eventLocation:String, eventSchedule:String,
         eventOrganizer:OrganizationProfile? )
    {
        self.name = eventName
        self.description = eventDescription
        self.webUrl = eventWebUrl
        
        self.location = eventLocation
        self.schedule = eventSchedule
        
        self.organizer = eventOrganizer
    }
    
}

class ODSocialNightEvent: ODEvent, SocialNightEvent {
    
    var dependentEvent: Event?
    
    var coverFee: Double?
    var dressCode: String?
    
    var deejay: DJProfile?
    
    var averageStar: Int = 0
    
    //ctors
    
    convenience init()
    {
        self.init(eventName:"", eventDescription:"", eventWebUrl:"",
        eventLocation:"", eventSchedule:"",
        eventOrganizer:nil)
    }
    
    init(eventName:String, eventDescription:String, eventWebUrl:String,
         eventLocation:String, eventSchedule:String,
         eventOrganizer:OrganizationProfile?,
         eventCover:Double? = 0.0, eventDressCode:String? = "No dress code!",
         eventDJ:DJProfile? = nil)
    {
        self.coverFee = eventCover
        self.dressCode = eventDressCode
        self.deejay = eventDJ
        
        super.init(eventName: eventName, eventDescription: eventDescription,
                   eventWebUrl: eventWebUrl,
                   eventLocation: eventLocation, eventSchedule: eventSchedule,
                   eventOrganizer: eventOrganizer)
    }
    
}

class ODClassEvent: ODEvent, ClassEvent {
    
    var danceType: String
    
    var fee: Double = 0.0
    var dressCode: Bool = false
    
    var instructors: Array<InstructorProfile> = []
    var students: Array<DancerProfile> = []
    
    //ctors
    
    convenience init()
    {
        self.init(eventName:"", eventDescription:"", eventWebUrl:"",
                  eventLocation:"", eventSchedule:"",
                  eventOrganizer:nil,
                  classDanceType : "", classFee:0.0, classDressCode:false,
                  instructors:Array<InstructorProfile>())
    }
    
    init(eventName:String, eventDescription:String, eventWebUrl:String,
         eventLocation:String, eventSchedule:String,
         eventOrganizer:OrganizationProfile?,
         classDanceType : String, classFee: Double = 0.0, classDressCode:Bool,
         instructors:Array<InstructorProfile>)
    {
        self.danceType = classDanceType
        self.fee = classFee
        self.dressCode = classDressCode
        
        self.instructors = instructors
        super.init(eventName: eventName, eventDescription: eventDescription,
                   eventWebUrl: eventWebUrl,
                   eventLocation: eventLocation, eventSchedule: eventSchedule,
                   eventOrganizer: eventOrganizer)
        
    }
}

