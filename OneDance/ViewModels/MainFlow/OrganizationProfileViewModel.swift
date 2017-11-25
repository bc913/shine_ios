//
//  OrganizationProfileViewModel.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation



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

