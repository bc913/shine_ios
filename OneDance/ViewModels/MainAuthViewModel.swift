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
    
    
    public func presentMainScreen() {
        print("The user is logged in")
        
    }
    
    public func presentEmailSignupScreen() {
        print("presentEmailAuth")
        coordinatorDelegate?.mainAuthViewModelDidSelect(authType: AuthType.Email)
    }
    
    public func presentLoginScreen() {
        print("presentLogin")
    }
    
    public func presentFacebookSignupScreen() {
        print("presentFacebook")
        coordinatorDelegate?.mainAuthViewModelDidSelect(authType: AuthType.Facebook)
    }
    
    // properties
    var facebookAuthLabel: String = "Sign up with Facebook"
    var emailAuthLabel: String = "Sign up with e-mail"
    var loginLabel: String = "Log in"
    
    
}
