//
//  ODUser.swift
//  OneDance
//
//  Created by Burak Can on 7/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class ODUser: UserProfile {
    var name: String
    var surName: String
    
    var info: String
    var photoUrl: String
    var webUrl: String
    
    var eMailAccount: String
    var phoneNumber: String
    
    // Ctors
    convenience init()
    {
        self.init(name: "", surName: "", userInfo: "", photoUrl: "", webUrl: "", userEmail: "", userPhone: "")
    }
    
    init(name:String, surName:String,
         userInfo:String, photoUrl: String, webUrl: String,
         userEmail:String, userPhone: String)
    {
        self.name = name
        self.surName = surName
        
        self.info = userInfo
        self.photoUrl = photoUrl
        self.webUrl = webUrl
        
        self.eMailAccount = userEmail
        self.phoneNumber = userInfo
    }
    
}

class ODDancer: ODUser, DancerProfile {
    var nickName: String
    
    // ctors
    
    convenience init()
    {
        self.init(name:"", surName:"",
                      userInfo:"", photoUrl: "", webUrl: "",
                      userEmail:"", userPhone: "",
                      nick:"")
    }
    
    init(name:String, surName:String,
         userInfo:String, photoUrl: String, webUrl: String,
         userEmail:String, userPhone: String,
         nick:String)
    {
        self.nickName = nick
        super.init(name: name, surName: surName,
                   userInfo: userInfo, photoUrl: photoUrl, webUrl: webUrl,
                   userEmail: userEmail, userPhone: userPhone)
        
    }
}

class ODOrganization: OrganizationProfile {
    var name: String
    var type: String
    
    var registeredLocation: String
    var phoneNumber: String?
    var eMailAddress: String
    var link: String?
    
    var averageStar: Int = 5
    var reviews = Array<String>()
    
    // Ctors
    convenience init()
    {
        
        self.init(orgName: "", orgType: "", orgLocation: "", orgPhoneNumber: "", orgEmail: "", orgWebUrl: "")
    }
    
    init(orgName: String, orgType: String,
         orgLocation:String, orgPhoneNumber:String?, orgEmail:String, orgWebUrl:String?
         )
    {
        self.name = orgName
        self.type = orgType
        
        self.registeredLocation = orgLocation
        self.phoneNumber = orgPhoneNumber
        self.eMailAddress = orgEmail
        self.link = orgWebUrl
        
    }
    
}

class ODEventOrganization: ODOrganization, EventOrganizationProfile {
    
    typealias EventItem = Event
    
    var registeredDJs: Array<DJProfile> = []
    
    var organizedEvents: Array<Event> = []
    var scheduledEvents: Array<Event> = []
}

class ODDanceAcademyOrganization: ODOrganization, DanceAcademyOrganizationProfile {
    
    var registeredInstructors = Array<InstructorProfile>()
    var registeredPerformanceGroups: Array<String> = []
    
    var currentlyTaughtClasses: Array<ClassEvent> = []
    var previouslyTaughtClasses: Array<ClassEvent> = []
    var prospectiveClasses: Array<ClassEvent> = []
    
    var taughtDanceTypes: Array<String> = []
    
}

class ODInstructor: ODDancer, InstructorProfile {
    
    var organization: OrganizationProfile?
    
    var yearsOfExperience: Int = 0
    
    var danceTypes: Array<String> = []
    
    var currentlyTaughtClasses: Array<ClassEvent> = []
    var previouslyTaughtClasses: Array<ClassEvent> = []
    var prospectiveClasses: Array<ClassEvent> = []
    
    //Ctors
    
    convenience init()
    {
        self.init(name:"", surName:"",
                  userInfo:"", photoUrl: "", webUrl: "",
                  userEmail:"", userPhone: "",
                  nick:"",
                  organization: nil, experience: 0)
    }
    
    init(name:String, surName:String,
         userInfo:String, photoUrl: String, webUrl: String,
         userEmail:String, userPhone: String,
         nick:String,
         organization: OrganizationProfile?, experience: Int)
    {
        
        self.organization = organization
        self.yearsOfExperience = experience
        super.init(name: name, surName: surName,
                   userInfo: userInfo, photoUrl: photoUrl, webUrl: webUrl,
                   userEmail: userEmail, userPhone: userPhone, nick: nick)
    }
}

class ODDeeJay: ODDancer, DJProfile {
    var danceTypes: Array<String> = []
    var organization: OrganizationProfile?
    
    //Events
    var eventsPlayed: Array<Event> = []
    var futureEvents: Array<Event> = []
    
    // Favorites
    var favoriteTopThreeSongs: Array<String> = []
    
    // Locations
    var locations: Array<String> = []
    
    //Ctors
    convenience init()
    {
        self.init(name:"", surName:"",
                  userInfo:"", photoUrl: "", webUrl: "",
                  userEmail:"", userPhone: "",
                  nick:"",
                  danceTypes: Array<String>(), organization:nil)
    }
    
    init(name:String, surName:String,
         userInfo:String, photoUrl: String, webUrl: String,
         userEmail:String, userPhone: String,
         nick:String,
         danceTypes: Array<String>, organization:OrganizationProfile?)
    {
        self.danceTypes = danceTypes
        self.organization = organization
        
        super.init(name: name, surName: surName,
                   userInfo: userInfo, photoUrl: photoUrl, webUrl: webUrl,
                   userEmail: userEmail, userPhone: userPhone, nick: nick)
    }
    
}


