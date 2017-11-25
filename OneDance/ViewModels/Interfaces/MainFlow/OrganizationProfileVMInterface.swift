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



//protocol DanceAcademyViewModelType : class {
//    
//    var model : DanceAcademyModelType? { get set }
//    
//    var name: String { get set }
//    var fullAddress: String { get set }
//    var danceTypes : [IDanceType] { get set }
//    var about: String { get set }
//    var email: String { get set }
//    
//    var phoneNumber: String { get set }
//    var webUrl: String { get set }
//    
//    
//    
//    
//    //
//    func createProfile()
//    func viewProfile()
//    func editProfile()
//}
