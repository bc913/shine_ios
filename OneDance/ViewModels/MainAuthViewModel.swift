//
//  MainAuthViewModel.swift
//  OneDance
//
//  Created by Burak Can on 9/14/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

typealias MainAuthVMCoordinatorDelegate = MainAuthViewModelCoordinatorDelegate & AuthChildViewModelCoordinatorDelegate

class MainAuthViewModel : MainAuthViewModelType {
    
    weak var coordinatorDelegate : MainAuthVMCoordinatorDelegate?
    
    
    func skipAuth() {
        self.coordinatorDelegate?.viewModelDidSelectSkip()
    }
    
    public func presentEmailSignupScreen() {
        self.coordinatorDelegate?.viewModelDidSelectEmailSignup()
    }
    
    public func presentLoginScreen() {
       self.coordinatorDelegate?.viewModelDidSelectLogin()
    }
    
    public func presentFacebookSignupScreen() {
        //
    }
    
    // properties
    var facebookAuthLabel: String = "Sign up with Facebook"
    var emailAuthLabel: String = "Sign up with e-mail"
    var loginLabel: String = "Log in"
    
    
}
