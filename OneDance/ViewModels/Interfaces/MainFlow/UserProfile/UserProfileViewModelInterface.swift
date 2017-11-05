//
//  UserProfileViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 11/2/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol UserProfileViewModelCoordinatorDelegate : class {
    
}

protocol UserProfileViewModelViewDelegate : class {
    func viewModelDidFetchUserProfile(viewModel: UserProfileViewModelType)
}


protocol UserProfileViewModelType : class {
    
    var coordinatorDelegate : UserProfileViewModelCoordinatorDelegate? { get set }
    var viewDelegate : UserProfileViewModelViewDelegate? { get set }
    
    var userName : String { set get }
    var fullName : String { get set }
    var slogan : String { get set }
    var bioLink : String { get set }
    
    var followerCounter : String { get set }
    var followingCounter : String { get set }
    
    func fetch()
    
    var errorMessage : String { get }
    
}
