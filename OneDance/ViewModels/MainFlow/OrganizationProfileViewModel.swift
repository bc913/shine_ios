//
//  OrganizationProfileViewModel.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

typealias OrganizationVMCoordinatorDelegate = OrganizationViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol OrganizationViewModelCoordinatorDelegate : class {
    // Edit
    func viewModelDidRequestEditCreate(viewModel: OrganizationViewModelType)
    func viewModelDidFinishEditCreate(viewModel: OrganizationViewModelType)
    func viewModelDidCancelEditCreate(viewModel: OrganizationViewModelType)
}

protocol OrganizationViewModelViewDelegate : class {
    
    func organizationInfoDidChange(viewModel: OrganizationViewModelType)
    func organizationCreationDidSuccess(viewModel: OrganizationViewModelType)
    func organizationCreationDidCancelled(viewModel: OrganizationViewModelType)
}

protocol OrganizationViewModelType : class {
    var mode : ShineMode  { get set }
    weak var viewDelegate : OrganizationViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : OrganizationVMCoordinatorDelegate? { get set }
    var model : OrganizationType? { get set }
    
    var id : String { get set }
    var name : String? { get set }
    var about :String? { get set }
    
    var danceTypes : [DanceTypeItem]? { get set }
    var contactInfo : ContactInfoItem { get set }
    
    // Image
    var imageData : Data? { get set }

    //var photo : ImageType? { get set }
    var instructors : [UserItem]? { get set }
    var djs : [UserItem]? { get set }
    
    var hasClassForKids : Bool { get set }
    var hasPrivateClass : Bool { get set }
    var hasWeddingPackage : Bool { get set }
    
    var followers : Int { get set }
    var posts : Int { get set }
    
    func create()
    func cancel()
    func goBack()
    
    
}

class OrganizationViewModel : OrganizationViewModelType {
    
    var mode : ShineMode
    weak var viewDelegate : OrganizationViewModelViewDelegate?
    weak var coordinatorDelegate: OrganizationVMCoordinatorDelegate?
    var model : OrganizationType?
    
    var id : String
    var name : String?
    var about : String?
    
    var photoManager = PhotoManager.instance()
    
    // Dance types
    var danceTypes : [DanceTypeItem]?
    
    // Contact info
    var contactInfo : ContactInfoItem = ContactInfoItem()
    
    // Image
    var imageData: Data?
    
    var instructors : [UserItem]?
    var djs : [UserItem]?
    
    // Dance academy info
    var hasClassForKids : Bool = false
    var hasPrivateClass : Bool = false
    var hasWeddingPackage : Bool = false
    
    // Relationship
    var followers : Int = 0
    
    // Feed
    var posts : Int = 0
    
    init(mode: ShineMode, id: String = "") {
        self.mode = mode
        self.id = id
        
        // Initialize model
        if mode == .create {
            self.model = OrganizationModel()
            //self.updateViewModel()
        } else {
            let modelCompletionHandler = { (error: NSError?, model: OrganizationModel) in
                //Make sure we are on the main thread
                DispatchQueue.main.async {
                    guard let error = error else {
                        self.model = model
                        // Update view
                        self.viewDelegate?.organizationInfoDidChange(viewModel: self)
                        //self.updateViewModel()
                        //self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel: self)
                        return
                    }
                    //self.errorMessage = error.localizedDescription
                }
            }
            
            // Network call
            
        }
        
        
    }
    
    private func populateViewModel(){
        
        self.id = self.model?.id ?? ""
        self.name = self.model?.name ?? ""
        self.about = self.model?.about ?? ""
        
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
        
        
        // Contact info
        if let contact = self.model?.contact as? ContactInfo {
            self.contactInfo = ContactInfoItem(contactInfoModel: contact)
        } else {
            self.contactInfo = ContactInfoItem()
        }
        
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
        
        // Dance academy info
        self.hasClassForKids = self.model?.hasClassForKids ?? false
        self.hasPrivateClass = self.model?.hasPrivateClass ?? false
        self.hasWeddingPackage = self.model?.hasWeddingPackage ?? false
        
        // Relationship
        self.followers = self.model?.followerCounter ?? 0
        
        // Feed
        self.posts = self.model?.postsCounter ?? 0
        
    }
    
    private func updateModel() {
        
        self.model?.id = self.id
        self.model?.name = self.name
        self.model?.about = self.about

        // Dance types
        //TODO: Remove this code
        var danceItem = DanceTypeItem()
        danceItem.id = "0"
        danceItem.name = "Salsa"
        self.danceTypes?.append(danceItem)
        
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
        
        // Contact
        //TODO: Remove this code
        var loc = LocationItem()
        loc.id = "647fe149-815c-4a4b-92dd-2eaa307f5ce4"
        loc.name = "name"
        self.model?.contact = self.contactInfo.mapToLiteModel()
        
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
        
        // Dance acedemy info
        self.model?.hasClassForKids = self.hasClassForKids
        self.model?.hasPrivateClass = self.hasPrivateClass
        self.model?.hasWeddingPackage = self.hasWeddingPackage
        
        // Relationship
        self.model?.followerCounter = self.followers
        
        // Feed
        self.model?.postsCounter = self.posts
    }
    
    
    func create(){
        self.updateModel()
        
        let uploadPhotoCompletionHandler = { (error: NSError?) in
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
        
        let modelCompletionHandler = { (error: NSError?, orgId: String?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                if let err = error {
                    //self.errorMessage = error.localizedDescription
                } else {
                    
                    if self.imageData != nil && orgId != nil{
                        self.photoManager.uploadOrganizationImage(with: self.imageData!, orgId: orgId!, progressBlock: nil, completionHandler: nil, shineCompletionHandler: uploadPhotoCompletionHandler)
                    } else{
                        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
                        return
                    }
                }
            }
        }
        // Network request with model
        ShineNetworkService.API.Organization.create(model: self.model as! OrganizationModel, mainThreadCompletionHandler: modelCompletionHandler)
        
        }
        
    
    func cancel(){
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
        //self.viewDelegate?.organizationCreationDidCancelled(viewModel: self)
    }
    
    func editOrganiztionProfile(){
        
    }
    
    func deleteorganizationProfile(){
        
    }
    
    func goBack(){
        if self.mode != .create || self.mode != .edit {
            self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: self.mode)
        }
    }
}

