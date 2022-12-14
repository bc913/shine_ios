//
//  MainAuthViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 9/13/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

enum AuthType : String {
    case Email
    case Facebook
}

protocol MainAuthViewModelCoordinatorDelegate : class {
    func mainAuthViewModelDidSelectRegister(authType: AuthType)
    func mainAuthViewModelDidSelectLogin(viewModel: MainAuthViewModelType)
    func mainAuthViewModelDidSelectSkip(viewModel: MainAuthViewModelType)
}

protocol MainAuthViewModelType : class {
    
    // Properties
    var coordinatorDelegate : MainAuthVMCoordinatorDelegate? { get set }
    
    func skipAuth()
    func presentFacebookSignupScreen()
    func presentEmailSignupScreen()
    func presentLoginScreen()
    
    var facebookAuthLabel : String { get }
    var emailAuthLabel : String { get }
    var loginLabel : String { get }
}
