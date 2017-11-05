//
//  MainAuthViewModel.swift
//  OneDance
//
//  Created by Burak Can on 9/14/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class MainAuthViewModel : MainAuthViewModelType {
    
    weak var coordinatorDelegate : MainAuthViewModelCoordinatorDelegate?
    
    
    func skipAuth() {
        coordinatorDelegate?.mainAuthViewModelDidSelectSkip(viewModel: self)
    }
    
    public func presentEmailSignupScreen() {
        coordinatorDelegate?.mainAuthViewModelDidSelectRegister(authType: AuthType.Email)
    }
    
    public func presentLoginScreen() {
        coordinatorDelegate?.mainAuthViewModelDidSelectLogin(viewModel: self)
    }
    
    public func presentFacebookSignupScreen() {
        coordinatorDelegate?.mainAuthViewModelDidSelectRegister(authType: AuthType.Facebook)
    }
    
    // properties
    var facebookAuthLabel: String = "Sign up with Facebook"
    var emailAuthLabel: String = "Sign up with e-mail"
    var loginLabel: String = "Log in"
    
    
}
