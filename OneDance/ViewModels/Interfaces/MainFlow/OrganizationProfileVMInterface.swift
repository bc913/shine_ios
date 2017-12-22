//
//  OrganizationProfileVMInterface.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol OrganizationProfileVMViewDelegate : class{
    //
}

protocol OrganizationProfileVMCoordinatorDelegate : class{
    //
}
protocol OrganizationProfileViewModelType : class {
    
    //var model : OrganizationModelType? { get set }
    
    var viewDelegate : OrganizationProfileVMViewDelegate? { get set }
    var coordinatorDelegate : OrganizationProfileVMCoordinatorDelegate? { get set }
    
    var name: String { get set }
    
    var about: String { get set }
    var danceTypes : [IDanceType] { get set }
 
    
    // Contact info
    var email: String { get set }
    var phoneNumber: String { get set }
    var webUrl: String { get set }
    var facebookUrl : String { get set }
    var instagramUrl : String { get set }
    
    // Class info
    var hasClassForKids : Bool? { get set }
    var hasPrivateClasses : Bool? { get set }
    var instructors : [InstructorProfileModelType]?{ get set }
    
    //
    func createProfile()
    func viewProfile()
    func editProfile()
    
    //
    var numberOfItems: Int { get }
    func itemAtIndex(_ index: Int) -> FormItem?
    //func useItemAtIndex(_ index: Int)
    
}

protocol OrganizationViewModelViewDelegate : class {
    func organizationInfoDidChange(viewModel: OrganizationViewModelType)
}

protocol OrganizationViewModelType : class {
    var mode : ViewModelMode { get set }
    var viewDelegate : OrganizationViewModelViewDelegate? { get set }
    //var coordinatorDelegate : OrganizationProfileVMCoordinatorDelegate? { get set }
    var model : OrganizationType { get set }
    
    var id : String { get set }
    var name : String { get set }
    var about :String { get set }
    
    var danceTypes : [String] { get set }
    
    var contactInfo : ContactInfoItem? { get set }
    
    //var photo : ImageType? { get set }
    var instructorList : [UserItem] { get set }
    var djList : [UserItem] { get set }
    
    var hasClassForKids : Bool { get set }
    var hasPrivateClass : Bool { get set }
    var hasWeddingPackage : Bool { get set }
    
    var followers : Int { get set }
    var posts : Int { get set }
    
    func createOrganizationProfile()
    
    
}
