//
//  SignUpViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

// Email

protocol EmailSignUpViewModelCoordinatorDelegate : class {
    func emailSignUpViewModelDidCreateAccount(viewModel: EmailSignUpViewModelType)
}

protocol EmailSignUpViewModelViewDelegate : class {
    func canSubmitStatusDidChange(_ viewModel: EmailSignUpViewModelType, status: Bool)
    func notifyUser(_ viewModel: EmailSignUpViewModelType, _ title: String, _ message: String)
}

protocol EmailSignUpViewModelType : class {
    
    var coordinatorDelegate : EmailSignUpViewModelCoordinatorDelegate? { get set }
    var viewDelegate : EmailSignUpViewModelViewDelegate? { get set }
    
    //
    var userName: String { get set }
    var name : String { get set }
    var surName: String { get set }
    var email: String { get set }
    var password: String { get set }
    
    var canSubmit : Bool { get }
    
    // Errors
    var errorMessage: String { get }
    
    func submit()
    
}
