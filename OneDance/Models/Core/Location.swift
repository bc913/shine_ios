//
//  Location.swift
//  OneDance
//
//  Created by Burak Can on 12/3/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

//import MapKit
//
//protocol Location {
//    //associatedtype Item
//    var mapItem : MKMapItem { get set }
//    
//    // Computed properties
//    // TODO: These properties can be parsed using Apple or Google MAPS API or mapItem property if the user do not provide any info rather than the name.
//    var name : String { get }
//    var coordinates:CLLocationCoordinate2D? { get }
//    var postalAddress : CLPlacemark { get } // BETA feature. test it.
//    var webUrl : String { get }
//    
//    // Dance related properties
//    var danceTypes : Array<String> { get set }
//    var likes : Int { get set }
//    var reviews : Array<String> { get set }
//    //var futureEvents : Array<Event> { get }
//}

//=============
// LocationLite
//=============
protocol LocationLiteType {
    
    var id : String? { get set }
    var name : String? { get set }
    
    var media : ImageType? { get set }
    
    var latitude : Double? { get set }
    var longitude : Double? { get set }
    
}

struct LocationLite : LocationLiteType {
    
    var id : String?
    var name : String?
    
    var media: ImageType?
    
    var latitude : Double?
    var longitude : Double?
    
    init() { }
    
    init?(json:[String:Any]){
        
        guard let lat = json["lat"] as? Double, let lon = json["lon"] as? Double,
            let name = json["name"] as? String,  let shineId = json["id"] as? String
            else {
                return nil
        }
        
        self.latitude = lat
        self.longitude = lon
        self.name = name
        self.id = shineId
        
        if let media = json["media"] as? [String:Any] {
            self.media = MediaImage(json: media)
        }
    }
}

extension LocationLite : JSONDecodable {
    var jsonData: [String : Any] {
        let img = self.media as? MediaImage
        return [
            "id" : self.id ?? "",
            "name" : self.name ?? "",
            "media" : img?.jsonData ?? [String:Any](),
            "lat" : self.latitude ?? 0.0,
            "lon" : self.longitude ?? 0.0
        ]
    }
}
