//
//  EventViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/16/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol EventViewModelViewDelegate : class {
    
    func editCreateDidSucceed(viewModel: EventViewModelType)
    func editCreateDidCancelled(viewModel: EventViewModelType)
    
}

protocol EventViewModelCoordinatorDelegate : class {
    
}

typealias EventVMCoordinatorDelegate = EventViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate


protocol EventViewModelType : class {
    
    weak var viewDelegate : EventViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : EventVMCoordinatorDelegate? { get set }
    var mode : ShineMode { get set }
    
    var id : String { get set }
    
    var title : String { get set }
    var description : String { get set }
    var ownerUser : UserItem? { get set }
    var ownerOrg : OrganizationLiteItem? { get set }
    
    var danceTypes : [DanceTypeItem]? { get set }
    
    var webUrl : String { get set }
    
    var location : LocationItem? { get set }
    var contactPerson : ContactPersonItem? { get set }
    
    //TODO: Imagetype
    
    // Attendance Info
    var interestedCounter : Int { get set }
    var goingCounter : Int { get set }
    var notGoingCounter : Int { get set }
    
    // Time
    var startTime : Date { get set }
    var endTime : Date { get set }
    var duration : Int { get }
    
    var danceLevel : DanceLevel? { get set }
    var eventType : EventType? { get set }
    var instructors : [UserItem]? { get set }
    var djs : [UserItem]? { get set }
    
    var hasWorkshop : Bool { get set }
    var hasPerformance : Bool { get set }
    
    // Event Policy
    var hasDressCode : Bool { get set }
    var partnerRequired : Bool { get set }
    var eventPolicyDescription : String? { get set }
    
    // Fee policy
    var feePolicy : FeePolicyItem? { get set }
    
    // Methods
    func create()
    func edit()
    func delete()
    func cancel()
    func goBack()
    
    
}


class EventViewModel : EventViewModelType {
    
    weak var viewDelegate : EventViewModelViewDelegate?
    weak var coordinatorDelegate : EventVMCoordinatorDelegate?
    
    var model : EventModel?
    var mode : ShineMode
    var id : String
    
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
        
        self.id = self.model?.id ?? ""
        self.title = self.model?.title ?? ""
        self.description = self.model?.description ?? ""
        
        // Owners
        if let ownerAsUser = self.model?.ownerUser as? UserLite {
            self.ownerUser = nil
            self.ownerUser = UserItem(userLiteModel: ownerAsUser)
        } else {
            self.ownerUser = nil
        }
        
        if let ownerAsOrg = self.model?.ownerOrganization as? OrganizationLite {
            self.ownerOrg = nil
            self.ownerOrg = OrganizationLiteItem(organizationLiteModel: ownerAsOrg)
        } else {
            self.ownerOrg = nil
        }
        
        // Dance types
        if let modelDances = self.model?.danceTypes, !modelDances.isEmpty {
            
            if self.danceTypes == nil {
                self.danceTypes = [DanceTypeItem]()
                self.danceTypes?.reserveCapacity(modelDances.count)
            } else {
                self.danceTypes?.removeAll()
            }
            
            for dance in modelDances {
                if let danceObj = dance as? DanceType {
                   self.danceTypes?.append(DanceTypeItem(danceTypeModel: danceObj))
                }
            }
        } else {
            self.danceTypes = nil
        }
        
        self.webUrl = self.model?.webUrl?.path ?? ""
        
        if let loc = self.model?.location as? LocationLite {
            self.location = LocationItem(locationLiteModel: loc)
        } else {
            self.location = nil
        }
        
        if let contact = self.model?.contact {
            self.contactPerson = ContactPersonItem(model: contact)
        } else {
            self.contactPerson = nil
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
        
        if let modelInstructors = self.model?.instructors, !(modelInstructors.isEmpty) {
            
            if self.instructors != nil {
                self.instructors?.removeAll()
            } else {
                self.instructors = [UserItem]()
                self.instructors?.reserveCapacity(modelInstructors.count)
            }
            
            for instLite in modelInstructors {
                if let insLiteItem = instLite as? UserLite{
                    self.instructors!.append(UserItem(userLiteModel: insLiteItem))
                }
            }
        } else {
            self.instructors = nil
        }
        
        if let modelDjs = self.model?.djs, !(modelDjs.isEmpty) {
            
            if self.djs != nil {
                self.djs!.removeAll()
            } else {
                self.djs = [UserItem]()
                self.djs?.reserveCapacity(modelDjs.count)
            }
            
            for modelDj in modelDjs {
                if let modelDjLite = modelDj as? UserLite {
                    self.djs!.append(UserItem(userLiteModel: modelDjLite))
                }
            }
        } else {
            self.djs = nil
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
        } else {
            self.feePolicy = nil
        }
        
        
        
    }
    
    func updateModel(){
        
        self.model?.id = self.id
        self.model?.title = self.title
        self.model?.description = self.description
        
        // Owners
        self.model?.ownerUser = self.ownerUser?.mapToLiteModel()
        self.model?.ownerOrganization = self.ownerOrg?.mapToLite()
        
        // Dance types
        if let selectedDances = self.danceTypes, !(selectedDances.isEmpty), self.model != nil {
            
            self.model!.danceTypes = nil
            self.model!.danceTypes = [DanceType]()
            self.model!.danceTypes!.reserveCapacity(selectedDances.count)
                
            for danceItem in selectedDances {
                self.model!.danceTypes!.append(danceItem.mapToModel())
            }
            
        } else{
            self.model?.danceTypes = nil
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
        
        if let instructorList = self.instructors, !(instructorList.isEmpty), self.model != nil {
            
            self.model!.instructors = nil
            self.model!.instructors = [UserLite]()
            self.model!.instructors!.reserveCapacity(instructorList.count)
            
            for instItem in instructorList {
                self.model!.instructors!.append(instItem.mapToLiteModel())
            }

        } else {
            self.model?.instructors = nil
        }
        
        if let djList = self.djs, !(djList.isEmpty), self.model != nil {
            
            self.model!.djs = nil
            self.model!.djs = [UserLite]()
            self.model!.djs!.reserveCapacity(djList.count)
            
            for djItem in djList {
                self.model!.djs!.append(djItem.mapToLiteModel())
            }
            
        } else {
            self.model?.djs = nil
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
    var ownerUser : UserItem?
    var ownerOrg : OrganizationLiteItem?
    
    var danceTypes : [DanceTypeItem]?
    
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
    
    // Methods
    
    func create(){
        //Network request
        self.updateModel()
        
        let modelCompletionHandler = { (error: NSError?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                guard let error = error else {
                    // Update view
                    self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
                    return
                }
                //self.errorMessage = error.localizedDescription
            }
        }
        // Network request with model
        ShineNetworkService.API.Event.create(model: self.model!, mainThreadCompletionHandler: modelCompletionHandler)
        
        // Notify timeline to refresh through coordinator
    }
    
    func edit(){
        // Network request
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
    }
    
    func delete(){
        
    }
    
    func cancel(){
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
    }
    
    func goBack(){
        if self.mode != .create || self.mode != .edit {
            self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: self.mode)
        }
    }
    
}
