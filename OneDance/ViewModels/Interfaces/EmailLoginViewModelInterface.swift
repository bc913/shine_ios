//
//  EmailLoginViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 10/9/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol EmailLoginViewModelCoordinatorDelegate : class {
    func userDidLogin(viewModel: EmailLoginViewModelType)
}

protocol EmailLoginViewModelViewDelegate : class {
    func canSubmitStatusDidChange(_ viewModel: EmailLoginViewModelType, status: Bool)
    func notifyUser(_ viewModel: EmailLoginViewModelType, _ title: String, _ message: String)
}


protocol EmailLoginViewModelType : class {
    
    // Delegates
    var coordinatorDelegate : EmailLoginViewModelCoordinatorDelegate? { get set }
    var viewDelegate : EmailLoginViewModelViewDelegate? { get set }
    
    var email : String { get set }
    var password : String { get set }
    
    var canSubmit : Bool { get }
    var errorMessage : String { get }
    
    func submit()
}
