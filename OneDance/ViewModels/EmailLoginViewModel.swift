//
//  EmailLoginViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class EmailLoginViewModel : EmailLoginViewModelType {
    
    weak var coordinatorDelegate: EmailLoginViewModelCoordinatorDelegate?
    weak var viewDelegate: EmailLoginViewModelViewDelegate?
    
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
        return emailIsValidFormat && passwordIsValidFormat
    }
    
    /// Errors
    fileprivate(set) var errorMessage: String = "" {
        didSet {
            if oldValue != errorMessage {
                viewDelegate?.notifyUser(self, "Error", errorMessage, completion: nil)
            }
        }
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
        print("EmailLogin :: submit()")
        
        
        let completion : ((EmailLoginViewModelType) -> ())? = self.coordinatorDelegate?.userDidLogin
        let modelCompletionHandler = { (error: NSError?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.viewDelegate?.notifyUser(self, "Success", "You are logged in.", completion: completion)
                    //self.coordinatorDelegate?.userDidLogin(viewModel: self)
                    return
                }
                self.errorMessage = error.localizedDescription
            }
        }
        
        ShineNetworkService().loginUserWith( email: self.email,
                                             password: self.password,
                                             mainThreadCompletionHandler: modelCompletionHandler)
        
        
    }
    
    
}
