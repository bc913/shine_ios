//
//  ProfileInfoSetupViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 10/24/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol ProfileInfoSetupViewModelCoordinatorDelegate : class {
    func userDidFinishProfileSetup(viewModel: ProfileInfoSetupViewModelType)
}

protocol ProfileInfoSetupViewModelViewDelegate : class {
    func notifyUserForNickNameSelection()
}


protocol ProfileInfoSetupViewModelType : class {
    
    var coordinatorDelegate : ProfileInfoSetupViewModelCoordinatorDelegate? { get set }
    var viewDelegate : ProfileInfoSetupViewModelViewDelegate? { get set }
    
    
    var userName : String { get set }
    var slogan : String { get set }
    var link : String { get set }
    
    var errorMessage : String { get }
    
    func submit()
}
