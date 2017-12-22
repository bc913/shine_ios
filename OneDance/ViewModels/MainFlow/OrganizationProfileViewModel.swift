//
//  OrganizationProfileViewModel.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class OrganizationViewModel : OrganizationViewModelType {
    
    var mode : ViewModelMode
    var viewDelegate : OrganizationViewModelViewDelegate?
    
    var id : String = ""
    var name : String = ""
    var about :String = ""
    
    // Dance types
    var danceTypes = [String]()
    
    // Contact info
    var contactInfo : ContactInfoItem?
    
    var instructorList = [UserItem]()
    var djList = [UserItem]()
    
    // Dance academy info
    var hasClassForKids : Bool = false
    var hasPrivateClass : Bool = false
    var hasWeddingPackage : Bool = false
    
    // Relationship
    var followers : Int = 0
    
    // Feed
    var posts : Int = 0
    
    var model : OrganizationType  = Organization(){
        didSet{
            
            self.id = self.model.id ?? ""
            self.name = self.model.name ?? ""
            self.about = self.model.about ?? ""
            
            // DAnce types
            if self.danceTypes.count != 0 {
                self.danceTypes.removeAll()
            }
            for danceItem in self.model.danceTypes {
                self.danceTypes.append(danceItem.name)
            }
            
            // Cotact info
            if let contact = self.model.contact as? ContactInfo {
                self.contactInfo = ContactInfoItem(contactInfoModel: contact)
            }
            
            // Instructors
            if !self.instructorList.isEmpty {
                self.instructorList.removeAll()
            }
            
            if let insts = self.model.instructors {
                for instructor in insts {
                    if let userLiteItem = instructor as? UserLite {
                        self.instructorList.append(UserItem(userLiteModel: userLiteItem))
                    }
                }
            }
            
            // DJs
            if !self.djList.isEmpty {
                self.djList.removeAll()
            }
            
            if let djs = self.model.djs {
                for dj in djs {
                    if let djLiteItem = dj as? UserLite {
                        self.djList.append(UserItem(userLiteModel: djLiteItem))
                    }
                }
            }
            
            // Dance academy info
            self.hasClassForKids = self.model.hasClassForKids
            self.hasPrivateClass = self.model.hasPrivateClass
            self.hasWeddingPackage = self.model.hasWeddingPackage
            
            // Relationship
            self.followers = self.model.followerCounter ?? 0
            
            // Feed
            self.posts = self.model.postsCounter ?? 0
            
            
            
        }
    }
    
    init(mode: ViewModelMode, id: String = "") {
        self.mode = mode
        
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
    
    private func updateViewModel(){
        
        self.id = self.model.id ?? ""
        self.name = self.model.name ?? ""
        self.about = self.model.about ?? ""
        
        // DAnce types
        if self.danceTypes.count != 0 {
            self.danceTypes.removeAll()
        }
        for danceItem in self.model.danceTypes {
            self.danceTypes.append(danceItem.name)
        }
        
        // Contact info
        if let contact = self.model.contact as? ContactInfo {
            self.contactInfo = ContactInfoItem(contactInfoModel: contact)
        }
        
        // Instructors
        if !self.instructorList.isEmpty {
            self.instructorList.removeAll()
        }
        
        if let insts = self.model.instructors {
            for instructor in insts {
                if let userLiteItem = instructor as? UserLite {
                    self.instructorList.append(UserItem(userLiteModel: userLiteItem))
                }
            }
        }
        
        // DJs
        if !self.djList.isEmpty {
            self.djList.removeAll()
        }
        
        if let djs = self.model.djs {
            for dj in djs {
                if let djLiteItem = dj as? UserLite {
                    self.djList.append(UserItem(userLiteModel: djLiteItem))
                }
            }
        }
        
        // Dance academy info
        self.hasClassForKids = self.model.hasClassForKids
        self.hasPrivateClass = self.model.hasPrivateClass
        self.hasWeddingPackage = self.model.hasWeddingPackage
        
        // Relationship
        self.followers = self.model.followerCounter ?? 0
        
        // Feed
        self.posts = self.model.postsCounter ?? 0
        
    }
    
    private func updateModel() {
        
        self.model.id = self.id
        self.model.name = self.name
        self.model.about = self.about

        var selectedDanceTypes = [IDanceType]()
        var idCounter = 1
        for dance in self.danceTypes {
            selectedDanceTypes.append(DanceType(name:dance, id:idCounter))
            idCounter = idCounter + 1
        }
        self.model.danceTypes = selectedDanceTypes
        
        // Contacct
        self.model.contact = self.contactInfo?.mapToLiteModel()
        
        // Instructors
        var instructors = [UserLite]()
        for instructorItem in self.instructorList {
            instructors.append(instructorItem.mapToLiteModel())
        }
        self.model.instructors = instructors
        
        // DJs
        var djs = [UserLite]()
        for djItem in self.djList {
            djs.append(djItem.mapToLiteModel())
        }
        
        self.model.djs = djs
        
        // Dance acedemy info
        self.model.hasClassForKids = self.hasClassForKids
        self.model.hasPrivateClass = self.hasPrivateClass
        self.model.hasWeddingPackage = self.hasWeddingPackage
        
        // Relationship
        self.model.followerCounter = self.followers
        
        // Feed
        self.model.postsCounter = self.posts
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

