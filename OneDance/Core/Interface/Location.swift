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
    var name : String { get }
    var coordinates:CLLocationCoordinate2D? { get }
    
    var futureEvents : Array<Event> { get }
    
    
    // 
    var danceTypes : Array<String> { get set }
    var likes : Int { get set }
    var reviews : Array<String> { get set }
    
    
    
}
