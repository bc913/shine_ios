//
//  Users.swift
//  OneDance
//
//  Created by Burak Can on 7/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol UserProfile {
    var name : String { get set }
    var surName : String { get set }
    
    var info : String { get set } // slogan 
    var photoUrl : String { get set }
    var webUrl : String { get set }
    
    var eMailAccount : String { get set }
    var phoneNumber : String { get set }
    
}

// Butun kullanicilar Dancer Profile olusturmak zorunda
protocol DancerProfile : UserProfile {
    var nickName : String { get set }
    
    /*
    var favoriteEvents : Array<String> { get set }
    var favoriteDanceTypes : Array <String> { get set } // En sevdigi ucu gosterilsin profilde
    var favoriteLocations : Array<String> { get set }
    var favoriteDancers : Array<DancerProfile> { get set }
    var favoriteDJs : Array<String> { get set }
    var favoriteInstructors : Array <String> { get set }
    var favoriteSong : Array <String> { get set }
    
    // Attended events
    var attendedEvents : Array<String> { get set }
    var interestedEvents : Array<String> { get set }
    
    // Media
    /*
    - Photos
    - Videos
     
    */
    */
}

// Kullanicilara dance events ve classlar duzenleyip duzenlemedigi sorulacak
// Event organizator veya dans okulu olabilir
protocol OrganizationProfile {
    
    var name : String { get set }
    var type : String { get set } // Freelance or solid - enum
    
    // Contact Details
    var registeredLocation : String { get set } // Can be a solid class
    var phoneNumber : String? { get set } // not required
    var eMailAddress : String { get set }
    var link : String? { get set }
    
    // Stars and reviews
    var averageStar : Int { get set }
    var reviews : Array <String> { get set }
}

protocol EventOrganizationProfile {
    
    associatedtype EventItem
    
    // DJs
    var registeredDJs : Array <DJProfile> { get set } // freelance ise tek kendi profili olacak
    
    // Events
    var organizedEvents : Array <EventItem> { get set } // Array of events
    var scheduledEvents : Array <EventItem> { get set } // Array of events
}

protocol DanceAcademyOrganizationProfile {
    
    // Registered instructors, DJs and Dancers
    var registeredInstructors : Array <InstructorProfile> { get set } // Check for the protocl arrays
    var registeredPerformanceGroups : Array <String> { get set }
    
    // Classes
    var currentlyTaughtClasses : Array<ClassEvent> {get set }
    var previouslyTaughtClasses : Array <ClassEvent> { get set }
    var prospectiveClasses : Array <ClassEvent> { get set }
    
    // Dance types - computed property olabilir
    var taughtDanceTypes : Array<String> { get set }
    
    // TODO: Registered performance teams
}

// Bir instructor ayni zamanda DJ olabilir
protocol InstructorProfile {
    
    var organization : OrganizationProfile? { get set }
    
    // Profile 
    var yearsOfExperience : Int { get set }
    
    // Dance types
    var danceTypes : Array <String> { get set }
    
    // Classes
    var currentlyTaughtClasses : Array<ClassEvent> {get set }
    var previouslyTaughtClasses : Array <ClassEvent> { get set }
    var prospectiveClasses : Array <ClassEvent> { get set }
}

protocol DJProfile {
    
    // Dance types for which (s)he played
    var danceTypes : Array <String> { get set }
    var organization : OrganizationProfile? { get set }
    
    // Events
    var eventsPlayed : Array<Event> { get set }
    var futureEvents : Array<Event> { get set }
    
    // Favorites
    var favoriteTopThreeSongs : Array <String> { get set }
    
    // Locations
    // Yani nerede calmis veya genelde nerede caliyor
    // Eventlerden elde edilebilir. Computed property
    var locations : Array<String> { get set }
    
    
}

