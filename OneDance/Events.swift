//
//  Events.swift
//  OneDance
//
//  Created by Burak Can on 7/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol Event {
    
    var name : String { get set }
    var description : String { get set }
    var webUrl : String { get set } // Link
    var discussion : Array<String> { get set }
    
    var location : String { get set }
    var schedule : String { get set } // TODO:Schedule class
    
    var organizer : OrganizationProfile? { get set }
    
    var likeCounter : Int? { get set }
    var interestedDancers : Array <DancerProfile> { get set }
    
    // TODO : Facebook and Instagram
    
    // Media
    var imageUrls : Array<String> { get set }
    var videoUrls : Array<String> { get set }
    
}

protocol SocialNightEvent {
    
    var dependentEvent : Event? { get set }
    
    var coverFee : Double? { get set }
    var dressCode : String? { get set }
    
    var deejay : DJProfile? { get set }
    
    var averageStar : Int { get set }
    
    // TODO: AnyPerformance???
    
    
    
}

protocol ClassEvent { // Scheduled class and workshop
    var danceType : String { get set }
    
    var fee : Double { get set }
    var dressCode : Bool { get set }
    
    var instructors : Array <InstructorProfile> { get set }
    var students : Array <DancerProfile> { get set }
    
    //TODO: Media
}
