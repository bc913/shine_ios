//
//  Helper.swift
//  This class includes item definitions to be used in ViewModels and Views.
//  They are mapped from/to the corresponding models.
//  OneDance
//
//  Created by Burak Can on 12/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

enum ViewModelMode {
    case edit
    case viewOnly
    case create
    case delete
}

enum ShineMode {
    case edit
    case viewOnly
    case create
    case delete
}
//============
// DanceType item
//============

struct DanceTypeItem {
    var name : String = ""
    var id : String = ""
    
    init() {}
    init(danceTypeModel: IDanceType) {
        self.mapFromModel(danceTypeModel: danceTypeModel)
    }
    
    func mapToModel() -> IDanceType {
        let danceTypeObj = DanceType(name: self.name, id: Int(self.id)!)
        return danceTypeObj
    }
    
    mutating func mapFromModel(danceTypeModel: IDanceType){
        self.name = danceTypeModel.name
        self.id = String(danceTypeModel.id)
    }
}

//============
// FeeItem
//============

struct FeeOptionItem {
    
    var type : String = FeeType.undefined.rawValue
    var value : Double = 0
    var numberOfSessions : Int? // Depends on type
    
    init() { }
    init(type: String, value: Double, sessions: Int) {
        self.type = type
        self.value = value
        self.numberOfSessions = sessions
    }
    
    init(model: FeeOptionType) {
        self.mapFromModel(model: model)
    }
    
    mutating func mapFromModel(model: FeeOptionType) {
        
        self.type = model.type?.rawValue ?? FeeType.undefined.rawValue
        self.value = model.value ?? 0
        self.numberOfSessions = model.numberOfSessions
    }
    
    func mapToModel() -> FeeOptionType{
        
        return FeeOption(typeStr: self.type, feeValue: self.value, sessions: self.numberOfSessions)
        
    }
}

//============
// FeePolicyItem
//============

struct FeePolicyItem {
    
    var options : [FeeOptionItem]?
    var description : String?
    
    init() { }
    init(options: [FeeOptionItem], description: String = "") {
        self.options = options
        self.description = description
    }
    
    init(model: FeePolicyType) {
        self.mapFromModel(model: model)
    }
    
    mutating func mapFromModel(model: FeePolicyType) {
        
        if let modelOptions = model.options, !modelOptions.isEmpty {
            
            if self.options == nil {
                self.options = [FeeOptionItem]()
            } else {
                if !(self.options!.isEmpty) {
                    self.options!.removeAll()
                }
            }
            
            for modelOpt in modelOptions {
                self.options!.append(FeeOptionItem(model: modelOpt))
            }
        }
        
        if let modelDesc = model.description {
            self.description = modelDesc
        }
    }
    
    func maptoModel() -> FeePolicyType {
        
        if let optionItems = self.options, !optionItems.isEmpty {
            
            var options = [FeeOption]()
            options.reserveCapacity(optionItems.count)
            
            for optionItem in optionItems {
                if let option = optionItem.mapToModel() as? FeeOption {
                    options.append(option)
                }
            }
            
            return FeePolicy(options: options, desc: self.description ?? "")
            
        } else {
            return FeePolicy()
        }
    }
}


//============
// UserItem
//============
struct UserItem {
    
    
    // TODO: Add media type
    var userId : String = ""
    var fullname : String = ""
    var username : String = ""
    
    init() { }
    init(userLiteModel: UserLite) {
        self.mapFromLiteModel(userLiteModel: userLiteModel)
    }
    
    func mapToLiteModel() -> UserLite {
        
        var userObj = UserLite()
        
        userObj.userId = self.userId
        userObj.fullName = self.fullname
        userObj.userName = self.username
        
        return userObj
    }
    
    mutating func mapFromLiteModel(userLiteModel: UserLite) {
        
        self.userId = userLiteModel.userId
        self.fullname = userLiteModel.fullName
        self.username = userLiteModel.userName
    }
}

//============
// DJProfileItem
//============

struct DJProfileItem {
    var bio : String = ""
    var danceTypes = [DanceTypeItem]()
    var sinceYear : Int = 0
    var canFreelance : Bool = false
    var relatedOrganizations : [OrganizationLiteItem]?
    
    init() {}
    init(model: DJProfileType) {
        self.mapFromModel(model: model)
    }
    
    func mapToModel() -> DJProfileType {
        
        var model : DJProfileType = DJProfile()
        
        model.bio = self.bio
        
        if !self.danceTypes.isEmpty{
            
            model.danceTypes = [DanceType]()
            model.danceTypes.reserveCapacity(self.danceTypes.count)
            
            for item in self.danceTypes {
                model.danceTypes.append(item.mapToModel())
            }
        }
        
        
        model.sinceYear = self.sinceYear
        model.canFreelance = self.canFreelance
        
        if self.relatedOrganizations != nil, !self.relatedOrganizations!.isEmpty {
            
            model.relatedOrganizations = [OrganizationLite]()
            model.relatedOrganizations?.reserveCapacity(self.relatedOrganizations!.count)
            
            for org in self.relatedOrganizations! {
                model.relatedOrganizations!.append(org.mapToLite())
            }
            
        }
        
        return model
    }
    
    mutating func mapFromModel(model: DJProfileType) {
        
        self.bio = model.bio
        self.sinceYear = model.sinceYear
        self.canFreelance = model.canFreelance
        
        // Dance types
        if !model.danceTypes.isEmpty {
            
            if !self.danceTypes.isEmpty {
                self.danceTypes.removeAll()
            }
            
            for dance in model.danceTypes {
                self.danceTypes.append(DanceTypeItem(danceTypeModel: dance))
            }
            
        }
        
        // Organizations
        if model.relatedOrganizations != nil, !model.relatedOrganizations!.isEmpty {
            
            if self.relatedOrganizations != nil {
                self.relatedOrganizations!.removeAll()
            } else {
                self.relatedOrganizations = [OrganizationLiteItem]()
            }
            
            for model in model.relatedOrganizations! {
                self.relatedOrganizations!.append(OrganizationLiteItem(organizationLiteModel: model))
            }
            
        }
        
    }
}
//============
// InstructorProfileItem
//============

struct InstructorProfileItem {
    var bio : String = ""
    var danceTypes = [DanceTypeItem]()
    var sinceYear : Int = 0
    var canFreelance : Bool = false
    var relatedOrganizations : [OrganizationLiteItem]?
    
    init() {}
    init(model: InstructorProfileType) {
        self.mapFromModel(model: model)
    }
    
    func mapToModel() -> InstructorProfileType {
        
        var model : InstructorProfileType = InstructorProfile()
        
        model.bio = self.bio
        
        if !self.danceTypes.isEmpty{
            
            model.danceTypes = [DanceType]()
            model.danceTypes.reserveCapacity(self.danceTypes.count)
            
            for item in self.danceTypes {
                model.danceTypes.append(item.mapToModel())
            }
        }
        
        
        model.sinceYear = self.sinceYear
        model.canFreelance = self.canFreelance
        
        if self.relatedOrganizations != nil, !self.relatedOrganizations!.isEmpty {
            
            model.relatedOrganizations = [OrganizationLite]()
            model.relatedOrganizations?.reserveCapacity(self.relatedOrganizations!.count)
            
            for org in self.relatedOrganizations! {
                model.relatedOrganizations!.append(org.mapToLite())
            }
            
        }
        
        return model
    }
    
    mutating func mapFromModel(model: InstructorProfileType) {
        
        self.bio = model.bio
        self.sinceYear = model.sinceYear
        self.canFreelance = model.canFreelance
        
        // Dance types
        if !model.danceTypes.isEmpty {
            
            if !self.danceTypes.isEmpty {
                self.danceTypes.removeAll()
            }
            
            for dance in model.danceTypes {
                self.danceTypes.append(DanceTypeItem(danceTypeModel: dance))
            }
            
        }
        
        // Organizations
        if model.relatedOrganizations != nil, !model.relatedOrganizations!.isEmpty {
            
            if self.relatedOrganizations != nil {
                self.relatedOrganizations!.removeAll()
            } else {
                self.relatedOrganizations = [OrganizationLiteItem]()
            }
            
            for model in model.relatedOrganizations! {
                self.relatedOrganizations!.append(OrganizationLiteItem(organizationLiteModel: model))
            }
            
        }
        
    }
}


//============
// OrganizationLiteItem
//============
struct OrganizationLiteItem {
    var id : String = ""
    var name : String = ""
    
    //TODO: Add image
    
    var followerCounter : Int = 0
    var location : LocationItem = LocationItem()
    
    init() {}
    init(organizationLiteModel: OrganizationLiteType) {
        self.mapFromLiteModel(organizationLiteModel: organizationLiteModel)
    }
    
    func mapToLite() -> OrganizationLiteType {
        
        var orgObj = OrganizationLite()
        
        orgObj.id = self.id
        orgObj.name = self.name
        orgObj.followerCounter = self.followerCounter
        orgObj.location = self.location.mapToLiteModel()
        
        return orgObj
        
    }
    
    mutating func mapFromLiteModel(organizationLiteModel: OrganizationLiteType){
        self.id = organizationLiteModel.id ?? ""
        self.name = organizationLiteModel.name ?? ""
        self.followerCounter = organizationLiteModel.followerCounter ?? 0
        
        if let orgLoc = organizationLiteModel.location as? LocationLite {
            self.location.mapFromLiteModel(locLiteModel: orgLoc)
        }
        
        
    }
}

//============
// LocationItem
//============

struct LocationItem {
    var id:String = ""
    var name: String = ""
    var address : String = ""
    var lon : Double = 0.0
    var lat : Double = 0.0
    
    init(){}
    init(locationLiteModel: LocationLite) {
        self.mapFromLiteModel(locLiteModel: locationLiteModel)
    }
    
    func mapToLiteModel() -> LocationLite {
        
        var locObj = LocationLite()
        
        locObj.id = self.id
        locObj.name = self.name
        locObj.latitude = self.lat
        locObj.longitude = self.lon
        
        return locObj
    }
    
    mutating func mapFromLiteModel(locLiteModel: LocationLite) {
        
        self.id = locLiteModel.id ?? ""
        self.name = locLiteModel.name ?? ""
        self.address = ""
        self.lon = locLiteModel.longitude ?? 0.0
        self.lat = locLiteModel.latitude ?? 0.0
        
    }
}
//============
// ContactPerson
//============

struct ContactPersonItem {
    var name : String = ""
    var email : String = ""
    var phone : String = ""
    
    init() {}
    init(model: ContactPersonType){
        self.mapFromModel(model: model)
    }
    
    func mapToModel() -> ContactPersonType {
        
        var model : ContactPersonType = ContactPerson()
        
        model.name = self.name
        model.email = self.email
        model.phone = self.phone
        
        return model
    }
    
    mutating func mapFromModel(model: ContactPersonType){
        
        self.name = model.name ?? ""
        self.email = model.email ?? ""
        self.phone = model.phone ?? ""
        
    }
}

//============
// ContactInfoItem
//============
struct ContactInfoItem {
    
    var email : String = ""
    var phone : String = ""
    var website : String = ""
    var instagramUrl : String = ""
    var facebookUrl : String = ""
    var locs = [LocationItem]()
    
    init() {}
    init(contactInfoModel: ContactInfo) {
        self.mapFromLiteModel(contactInfoModel: contactInfoModel)
    }
    
    func mapToLiteModel() -> ContactInfo {
        
        var locLites = [LocationLite]()
        
        for loc in self.locs {
            locLites.append(loc.mapToLiteModel())
        }
        
        var contact = ContactInfo()
        contact.email = self.email
        contact.phone = self.phone
        contact.website = URL(string: self.website)
        contact.facebookUrl = URL(string: self.facebookUrl)
        contact.instagramUrl = URL(string: self.instagramUrl)
        return contact
    }
    
    mutating func mapFromLiteModel(contactInfoModel: ContactInfo){
        
        self.email = contactInfoModel.email ?? ""
        self.phone = contactInfoModel.phone ?? ""
        self.website = contactInfoModel.website?.path ?? ""
        self.facebookUrl = contactInfoModel.facebookUrl?.path ?? ""
        self.instagramUrl = contactInfoModel.instagramUrl?.path ?? ""
        
        if let locs = contactInfoModel.locations {
            for locLiteObj in locs{
                var locItem = LocationItem()
                locItem.mapFromLiteModel(locLiteModel: locLiteObj as! LocationLite)
                self.locs.append(locItem)
            }
        }
        
    }
    
}
