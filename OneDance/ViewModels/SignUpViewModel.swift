//
//  SignUpViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire

// Email

protocol EmailSignUpViewModelCoordinatorDelegate : class {
    func emailSignUpViewModelDidCreateAccount(viewModel: EmailSignUpViewModelType)
}

typealias EmailSignUpVMCoordinatorDelegate = EmailSignUpViewModelCoordinatorDelegate & AuthChildViewModelCoordinatorDelegate

protocol EmailSignUpViewModelViewDelegate : class {
    func canSubmitStatusDidChange(_ viewModel: EmailSignUpViewModelType, status: Bool)
    func notifyUser(_ viewModel: EmailSignUpViewModelType, _ title: String, _ message: String)
}

protocol EmailSignUpViewModelType : class {
    
    var coordinatorDelegate : EmailSignUpVMCoordinatorDelegate? { get set }
    var viewDelegate : EmailSignUpViewModelViewDelegate? { get set }
    
    //
    var userName: String { get set }
    var name : String { get set }
    var email: String { get set }
    var password: String { get set }
    
    var canSubmit : Bool { get }
    
    // Errors
    var errorMessage: String { get }
    
    func submit()
    
}


class EmailSignUpViewModel: EmailSignUpViewModelType {
    
    weak var coordinatorDelegate: EmailSignUpVMCoordinatorDelegate?
    weak var viewDelegate: EmailSignUpViewModelViewDelegate?
    
    
    /// Name
    var userName: String = "" {
        didSet {
            if oldValue != userName {
                let oldCanSubmit = canSubmit
                userNameIsValidFormat = validateNameFormat(userName)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var userNameIsValidFormat: Bool = false
    
    /// Fullname
    var name: String = "" {
        didSet {
            if oldValue != name {
                let oldCanSubmit = canSubmit
                nameIsValidFormat = validateNameFormat(name)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var nameIsValidFormat: Bool = false
    
    
    /// Email
    var email: String = "" {
        didSet {
            if oldValue != email {
                let oldCanSubmit = canSubmit
                emailIsValidFormat = validateEmailFormat(email)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var emailIsValidFormat: Bool = false
    
    /// Password
    var password: String = "" {
        didSet {
            if oldValue != password {
                let oldCanSubmit = canSubmit
                passwordIsValidFormat = validatePasswordFormat(password)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var passwordIsValidFormat: Bool = false
    
    /// canSubmit
    var canSubmit: Bool {
        return emailIsValidFormat && passwordIsValidFormat && nameIsValidFormat  && userNameIsValidFormat
    }
    
    /// Errors
    fileprivate(set) var errorMessage: String = "" {
        didSet {
            if oldValue != errorMessage {
                viewDelegate?.notifyUser(self, "Error", errorMessage)
            }
        }
    }
    
    fileprivate func validateNameFormat(_ name: String) -> Bool
    {
        let trimmedString = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString.characters.count > 1
    }
    
    fileprivate func validateEmailFormat(_ email: String) -> Bool
    {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: email)
    }
    
    
    /// Validate password is at least 6 characters
    fileprivate func validatePasswordFormat(_ password: String) -> Bool
    {
        let trimmedString = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString.characters.count > 5
    }
    
    
    func submit() {
        print("EmailSignUpVM :: submit()")
        
        let modelCompletionHandler = { (error: NSError?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    //self.viewDelegate?.notifyUser(self, "Success", "Your Shine account is created.")
                    self.coordinatorDelegate?.viewModelDidCompleteEmailSignup()
                    return
                }
                self.errorMessage = error.localizedDescription
            }
        }
        
        let regModel = RegistrationModel(username: self.userName,
                                         fullname: self.name,
                                         email: self.email,
                                         password: self.password,
                                         facebookModel: nil)
        ShineNetworkService.API.User.createAccountWithEmail(model:regModel, mainThreadCompletionHandler: modelCompletionHandler)
        
        
    }
}
