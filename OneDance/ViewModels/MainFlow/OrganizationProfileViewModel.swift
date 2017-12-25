//
//  OrganizationProfileViewModel.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol OrganizationViewModelViewDelegate : class {
    func organizationInfoDidChange(viewModel: OrganizationViewModelType)
}

protocol OrganizationViewModelType : class {
    var mode : ViewModelMode { get set }
    var viewDelegate : OrganizationViewModelViewDelegate? { get set }
    //var coordinatorDelegate : OrganizationProfileVMCoordinatorDelegate? { get set }
    var model : OrganizationType? { get set }
    
    var id : String { get set }
    var name : String? { get set }
    var about :String? { get set }
    
    var danceTypes : [DanceTypeItem]? { get set }
    
    var contactInfo : ContactInfoItem? { get set }
    
    //var photo : ImageType? { get set }
    var instructors : [UserItem]? { get set }
    var djs : [UserItem]? { get set }
    
    var hasClassForKids : Bool { get set }
    var hasPrivateClass : Bool { get set }
    var hasWeddingPackage : Bool { get set }
    
    var followers : Int? { get set }
    var posts : Int? { get set }
    
    func createOrganizationProfile()
    
    
}

class OrganizationViewModel : OrganizationViewModelType {
    
    var mode : ViewModelMode
    var viewDelegate : OrganizationViewModelViewDelegate?
    var model : OrganizationType?
    
    var id : String
    var name : String?
    var about : String?
    
    // Dance types
    var danceTypes : [DanceTypeItem]?
    
    // Contact info
    var contactInfo : ContactInfoItem?
    
    var instructors : [UserItem]?
    var djs : [UserItem]?
    
    // Dance academy info
    var hasClassForKids : Bool = false
    var hasPrivateClass : Bool = false
    var hasWeddingPackage : Bool = false
    
    // Relationship
    var followers : Int?
    
    // Feed
    var posts : Int?
    
    init(mode: ViewModelMode, id: String = "") {
        self.mode = mode
        self.id = id
        
        // Initialize model
        if mode == .create {
            self.model = Organization()
            //self.updateViewModel()
        } else {
            let modelCompletionHandler = { (error: NSError?, model: Organization) in
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
            self.contactInfo = nil
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
        self.followers = self.model?.followerCounter
        
        // Feed
        self.posts = self.model?.postsCounter
        
    }
    
    private func updateModel() {
        
        self.model?.id = self.id
        self.model?.name = self.name
        self.model?.about = self.about

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
        
        // Contact
        self.model?.contact = self.contactInfo?.mapToLiteModel()
        
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
    
    
    func createOrganizationProfile(){
        self.updateModel()
        // Network request with model
        
    }
    
    func editOrganiztionProfile(){
        
    }
    
    func deleteorganizationProfile(){
        
    }
    
    // Contact info update
    func updatePhoneNumber(number: String){ self.contactInfo?.phone = number }
    func updateEmailInfo(email:String){ self.contactInfo?.email = email}
    func updateWebSiteUrlInfo(websiteUrl: String) { self.contactInfo?.website = websiteUrl }
    func updateFacebookUrlInfo(faceUrl: String) { self.contactInfo?.facebookUrl = faceUrl }
    func updateInstagramUrlInfo(instaUrl: String) { self.contactInfo?.instagramUrl = instaUrl }
    
}

struct OrganizationProfileItem : FormItem {
    var type: FormItemType.Input
    var title: String
    var rowsCount: Int
    
    
}

class OrganizationProfileViewModel : OrganizationProfileViewModelType {
    
    weak var coordinatorDelegate : OrganizationProfileVMCoordinatorDelegate?
    weak var viewDelegate : OrganizationProfileVMViewDelegate?
    
    var name: String = "" {
        didSet{
            print("NAme is updated to \(name)")
        }
    }
    
    var about: String = ""
    var danceTypes = [IDanceType]()
    
    var email: String = ""
    var phoneNumber: String = ""
    var webUrl: String = ""
    var facebookUrl : String = ""
    var instagramUrl : String = ""
    
    
    var hasClassForKids: Bool?{
        didSet{
            print("Has classes for kids: \(String(describing: hasClassForKids))")
        }
    }
    var hasPrivateClasses: Bool?
    var instructors: [InstructorProfileModelType]?
    
    init() {
        self.updateItems()
    }
    
    var numberOfItems: Int {
        if let items = self.organizationProfileItems {
            return items.count
        }
        
        return 0
    }
    
    func itemAtIndex(_ index: Int) -> FormItem? {
        if let items = self.organizationProfileItems, items.count > index {
            return items[index]
        }
        
        return nil
    }
    
    func createProfile() {
        //
        print("CreateOrganizationPRofile")
    }
    
    func viewProfile() {
        //
        print("viewProfile")
    }
    
    func editProfile() {
        //
        print("editProfile")
    }
    
    private var organizationProfileItems : [FormItem]? = []
    
    private func updateItems(){
        
        
        // Main Info
        let nameItem = OrganizationProfileItem(type: FormItemType.Input.ShortText, title: "Name", rowsCount: 1)
        organizationProfileItems?.append(nameItem)
        
        let fullAddressItem = OrganizationProfileItem(type: .ShortText, title: "Address", rowsCount: 1)
        organizationProfileItems?.append(fullAddressItem)
        
        let aboutItem = OrganizationProfileItem(type: .ShortText, title: "About", rowsCount: 1)
        organizationProfileItems?.append(aboutItem)
        
        let emailItem = OrganizationProfileItem(type: .ShortText, title: "E-mail", rowsCount: 1)
        organizationProfileItems?.append(emailItem)
        
        
        // Contact
        let phoneNumberItem = OrganizationProfileItem(type: .ShortText, title: "Phone", rowsCount: 1)
        organizationProfileItems?.append(phoneNumberItem)
        
        let webUrlItem = OrganizationProfileItem(type: .ShortText, title: "Link", rowsCount: 1)
        organizationProfileItems?.append(webUrlItem)
        
        
    }
    
    
    
    
}

