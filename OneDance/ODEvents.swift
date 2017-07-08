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
}

class ODSocialNightEvent: ODEvent, SocialNightEvent {
    
    var dependentEvent: Event?
    
    var coverFee: Double?
    var dressCode: String?
    
    var deejay: DJProfile?
    
    var averageStar: Int = 0
}

class ODClassEvent: ODEvent, ClassEvent {
    
    var danceType: String = ""
    
    var fee: Double = 0.0
    var dressCode: Bool = false
    
    var instructors: Array<InstructorProfile> = []
    var students: Array<DancerProfile> = []
}

