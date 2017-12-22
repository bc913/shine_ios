//
//  Media.swift
//  OneDance
//
//  Created by Burak Can on 11/25/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


struct MediaResolution {
    
    var width : Int?
    var height : Int?
    var url : URL?
    
    init?(json:[String:Any]) {
        
        if let width = json["width"] as? Int {
            self.width = width
        }
        
        if let height = json["height"] as? Int {
            self.height = height
        }
        
        if let url = json["url"] as? String {
            self.url = URL(string: url)!
        }
        
    }
}

struct Media {
    
    var thumbnail : MediaResolution?
    var standard : MediaResolution?
    var id : String?
    
    init?(json: [String:Any]) {
        
        if let mediaId = json["id"] as? String {
            self.id = mediaId
        }
        
        if let thumbnail = json["thumbnail"] as? [String:Any] {
            self.thumbnail = MediaResolution(json: thumbnail)
        }
        
        if let standard = json["standardImage"] as? [String:Any] {
            self.standard = MediaResolution(json: standard)
        }
        
        
        
    }
}
//=============
// ImageResolution
//=============
protocol ImageResolutionType {
    
    var width : Int { get set }
    var height : Int { get set }
    var url : URL? { get set }
}

struct MediaImageResolution : ImageResolutionType{
    
    var width : Int = 0
    var height : Int = 0
    var url : URL?
    
    init() {}
    
}

extension MediaImageResolution {
    
    init?(json:[String:Any]) {
        
        guard let width = json["width"] as? Int, let height = json["height"] as? Int,
            let url = json["url"] as? String else {
                
                return nil
        }
        
        self.width = width
        self.height = height
        self.url = URL(string: url)
        
    }
}

extension MediaImageResolution : JSONDecodable {
    var jsonData : [String:Any] {
        return [
            "width":self.width ,
            "height" : self.height,
            "url" : self.url?.absoluteString ?? ""
        ]
    }
}

protocol ImageType {
    var thumbnail : ImageResolutionType? { get set }
    var standard : ImageResolutionType? { get set }
    var id : String? { get set }
}

struct MediaImage : ImageType{
    
    var thumbnail : ImageResolutionType?
    var standard : ImageResolutionType?
    var id : String?
    
    init?(json: [String:Any]) {
        
        guard let mediaId = json["id"] as? String, let thumbnail = json["thumbnail"] as? [String:Any],
            let standard = json["standardImage"] as? [String:Any] else {
                return nil
        }
        
        self.id = mediaId
        self.thumbnail = MediaImageResolution(json: thumbnail)
        self.standard = MediaImageResolution(json: standard)
        
        
        
    }
}

extension MediaImage : JSONDecodable {
    var jsonData : [String:Any] {
        
        let thumb = self.thumbnail as? JSONDecodable
        let std = self.standard as? JSONDecodable
        
        return [
            "id" : self.id ?? "",
            "image" : true,
            "thumbnail" : thumb?.jsonData ?? NSNull(),
            "standardImage" : std?.jsonData ?? NSNull()
        ]
    }
}
