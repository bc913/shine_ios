//
//  Location.swift
//  OneDance
//
//  Created by Burak Can on 7/17/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import MapKit

protocol Location {
    //associatedtype Item
    var mapItem : MKMapItem { get set }
    
    // Computed properties
    // TODO: These properties can be parsed using Apple or Google MAPS API or mapItem property if the user do not provide any info rather than the name.
    var name : String { get }
    var coordinates:CLLocationCoordinate2D? { get }
    var postalAddress : CLPlacemark { get } // BETA feature. test it.
    var webUrl : String { get }
    
    // Dance related properties
    var danceTypes : Array<String> { get set }
    var likes : Int { get set }
    var reviews : Array<String> { get set }
    //var futureEvents : Array<Event> { get }
}
