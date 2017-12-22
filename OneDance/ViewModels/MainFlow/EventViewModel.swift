//
//  EventViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/16/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol EventViewModelViewDelegate : class {
    
}

protocol EventViewModelCoordinatorDelegate : class {
    
}


protocol EventViewModelType : class {
    
}


class EventViewModel : EventViewModelType {
    
    weak var viewDelegate : EventViewModelViewDelegate?
    weak var coordinatorDelegate : EventViewModelCoordinatorDelegate?
    
    var model : EventModel?
    var mode : ShineMode
    var id : String?
    
    fileprivate var errorMessage : String?
    
    init(mode: ShineMode, id: String = "") {
        self.mode = mode
        self.id = id
        
        if mode == .create {
            self.model = EventModel()
        } else {
            let modelCompletionHandler = { (error: NSError?, model:EventModel?) in
                //Make sure we are on the main thread
                DispatchQueue.main.async {
                    print("Am I back on the main thread: \(Thread.isMainThread)")
                    guard let error = error else {
                        self.model = model
                        // Populate view Model
                        return
                    }
                    self.model = nil
                    self.errorMessage = error.localizedDescription
                    
                }
                
            }
            
            // Make the API call to get the event detail
        }
    }
    
    // Update
    func populateViewModel(){
        
        self.title = self.model?.title ?? ""
        self.description = self.model?.description ?? ""
        
        // Owners
        if let ownerAsUser = self.model?.ownerUser as? UserLite {
            self.ownerUser.mapFromLiteModel(userLiteModel: ownerAsUser)
        }
        
        if let ownerAsOrg = self.model?.ownerOrganization as? OrganizationLite {
            self.ownerOrg.mapFromLiteModel(organizationLiteModel: ownerAsOrg)
        }
        
        // Dance types
        if let modelDances = self.model?.danceTypes {
            
            if self.danceTypeItems == nil {
                self.danceTypeItems = [DanceTypeItem]()
                self.danceTypeItems?.reserveCapacity(modelDances.count)
            } else {
                self.danceTypeItems?.removeAll()
            }
            
            for dance in modelDances {
                if let danceObj = dance as? DanceType {
                   self.danceTypeItems?.append(DanceTypeItem(danceTypeModel: danceObj))
                }
            }
        }
        
        self.webUrl = self.model?.webUrl?.path ?? ""
        
        if let loc = self.model?.location as? LocationLite {
            self.location = LocationItem(locationLiteModel: loc)
        }
        
        if let contact = self.model?.contact {
            self.contactPerson = ContactPersonItem(model: contact)
        }
        
        // TODO: Image type
        
        // Attendance Info
        self.interestedCounter = self.model?.attendees?.interested ?? 0
        self.goingCounter = self.model?.attendees?.going ?? 0
        self.notGoingCounter = self.model?.attendees?.notGoing ?? 0
        
        // Time
        self.startTime = self.model?.startingTime ?? Date()
        self.endTime = self.model?.endTime ?? Date()
        
        // Dance
        self.danceLevel = self.model?.level
        self.eventType = self.model?.type
        
        if let modelInstructors = self.model?.instructors {
            
            if self.instructors != nil {
                self.instructors?.removeAll()
            } else {
                self.instructors = [UserItem]()
            }
            
            for instLite in modelInstructors {
                if let insLiteItem = instLite as? UserLite{
                    self.instructors!.append(UserItem(userLiteModel: insLiteItem))
                }
            }
        }
        
        if let modelDjs = self.model?.djs {
            
            if self.djs != nil {
                self.djs!.removeAll()
            } else {
                self.djs = [UserItem]()
            }
            
            for modelDj in modelDjs {
                if let modelDjLite = modelDj as? UserLite {
                    self.djs!.append(UserItem(userLiteModel: modelDjLite))
                }
            }
        }
        
        self.hasWorkshop = self.model?.hasWorkshop ?? false
        self.hasPerformance = self.model?.hasPerformance ?? false
        
        // Event Policy
        self.hasDressCode = self.model?.policy?.dressCode ?? false
        self.partnerRequired = self.model?.policy?.partnerRequired ?? false
        self.eventPolicyDescription = self.model?.policy?.other
        
        // Fee policy
        if let fee = self.model?.fee {
            self.feePolicy = FeePolicyItem(model: fee)
        }
        
        
        
    }
    
    func updateModel(){
        
        self.model?.title = self.title
        self.model?.description = self.description
        
        // Owners
        self.model?.ownerUser = self.ownerUser.mapToLiteModel()
        self.model?.ownerOrganization = self.ownerOrg.mapToLite()
        
        // Dance types
        if let selectedDances = self.danceTypeItems{
            
            if self.model != nil {
                
                if self.model?.danceTypes != nil || !(self.model?.danceTypes!.isEmpty)!{
                    self.model?.danceTypes?.removeAll()
                } else {
                    self.model?.danceTypes = [DanceType]()
                    self.model?.danceTypes?.reserveCapacity(selectedDances.count)
                }
                
                for danceItem in selectedDances {
                    self.model?.danceTypes?.append(danceItem.mapToModel())
                }
            }
        }
        
        self.model?.webUrl = URL(string: self.webUrl)
        
        self.model?.location = self.location?.mapToLiteModel()
        self.model?.contact = self.contactPerson?.mapToModel()
        
        // Attendance Info
        self.model?.attendees?.interested = self.interestedCounter
        self.model?.attendees?.going = self.goingCounter
        self.model?.attendees?.notGoing = self.notGoingCounter
        
        // Time
        self.model?.startingTime = self.startTime
        self.model?.endTime = self.endTime
        self.model?.duration = String(self.duration)
        
        // Dance
        self.model?.level = self.danceLevel
        self.model?.type = self.eventType
        
        if let instructorList = self.instructors {
            
            var insLiteList = [UserLite]()
            insLiteList.reserveCapacity(instructorList.count)
            
            for instItem in instructorList {
                insLiteList.append(instItem.mapToLiteModel())
            }
            
            self.model?.instructors = insLiteList
        }
        
        if let djList = self.djs {
            
            var djLiteList = [UserLite]()
            djLiteList.reserveCapacity(djList.count)
            
            for djItem in djList {
                djLiteList.append(djItem.mapToLiteModel())
            }
            
            self.model?.djs = djLiteList
        }
        
        self.model?.hasWorkshop = self.hasWorkshop
        self.model?.hasPerformance = self.hasPerformance
        
        // Event policy
        self.model?.policy?.dressCode = self.hasDressCode
        self.model?.policy?.partnerRequired = self.partnerRequired
        self.model?.policy?.other = self.eventPolicyDescription
        
        // Fee policy
        self.model?.fee = self.feePolicy?.maptoModel()
    }
    
    
    // Properties
    
    var title : String = ""
    var description : String = ""
    var ownerUser : UserItem = UserItem()
    var ownerOrg : OrganizationLiteItem = OrganizationLiteItem()
    
    var danceTypeItems : [DanceTypeItem]?
    
    var webUrl : String = ""
    
    var location : LocationItem?
    var contactPerson : ContactPersonItem?
    
    //TODO: Imagetype
    
    // Attendance Info
    var interestedCounter : Int = 0
    var goingCounter : Int = 0
    var notGoingCounter : Int = 0
    
    // Time
    var startTime : Date = Date()
    var endTime : Date = Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date()
    
    var duration : Int {
        get {
           return Calendar.current.dateComponents([.hour], from: self.startTime, to:self.endTime).hour ?? 0
        }
    }
    
    var danceLevel : DanceLevel?
    var eventType : EventType?
    var instructors : [UserItem]?
    var djs : [UserItem]?
    
    var hasWorkshop : Bool = false
    var hasPerformance : Bool = false
    
    // Event Policy
    var hasDressCode : Bool = false
    var partnerRequired : Bool = false
    var eventPolicyDescription : String?
    
    // Fee policy
    var feePolicy : FeePolicyItem?
    
    
    
    
    
}
