//
//  ODUser.swift
//  OneDance
//
//  Created by Burak Can on 7/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class ODUser: UserProfile {
    var name: String = ""
    var surName: String = ""
    
    var info: String = ""
    var photoUrl: String = ""
    var link: String = ""
    
    var eMailAccount: String = ""
    var phoneNumber: String = ""
    
}

class ODDancer: ODUser, DancerProfile {
    var nickName: String = ""
}

class ODOrganization: OrganizationProfile {
    var name: String = ""
    var type: String = ""
    
    var registeredLocation: String = ""
    var phoneNumber: String?
    var eMailAddress: String = ""
    var link: String?
    
    var averageStar: Int = 0
    var reviews = Array<String>()
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
}


