//
//  OrganizationModel.swift
//  OneDance
//
//  Created by Burak Can on 11/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol OrganizationMainInfo {
    var name : String { get set }
    var fullAddress : String { get set }
    var danceTypes : [IDanceType] { get set }
    var about : String { get set }
    var email : String { get set }
}

protocol OrganizationContactInfo {
    var phoneNumber : String { get set }
    var webUrl : String { get set }
    // Facebook ve Instagram infosu da eklenebilir
    
}

protocol DanceAcademyDetails {
    var hasClassForKids : Bool { get set }
    var hasPrivateClass : Bool { get set }
    var instructors : [InstructorProfileModelType] { get set }
    
}

protocol OrganizationModelType :  OrganizationMainInfo, OrganizationContactInfo {
    
    
}

protocol DanceAcademyModelType : OrganizationModelType, DanceAcademyDetails  {
    
}

struct OrganizationModel : OrganizationModelType {
    
    var name: String = ""
    var fullAddress: String = ""
    var danceTypes = [IDanceType]()
    var about: String = ""
    var email: String = ""
    
    var phoneNumber: String = ""
    var webUrl: String = ""
    
}

struct DanceAcademyModel : DanceAcademyModelType {
    var name: String = ""
    var fullAddress: String = ""
    var danceTypes = [IDanceType]()
    var about: String = ""
    var email: String = ""
    
    var phoneNumber: String = ""
    var webUrl: String = ""
    
    var hasClassForKids: Bool = false
    var hasPrivateClass: Bool = false
    var instructors = [InstructorProfileModelType]()
    
}

