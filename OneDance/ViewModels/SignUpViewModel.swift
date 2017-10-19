//
//  SignUpViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire


class EmailSignUpViewModel: EmailSignUpViewModelType {
    
    weak var coordinatorDelegate: EmailSignUpViewModelCoordinatorDelegate?
    weak var viewDelegate: EmailSignUpViewModelViewDelegate?
    
    
    /// Name
    var userName: String = "" {
        didSet {
            if oldValue != userName {
                let oldCanSubmit = canSubmit
                nameIsValidFormat = validateNameFormat(userName)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var nameIsValidFormat: Bool = false
    
    /// Surname
    var userSurname: String = "" {
        didSet {
            if oldValue != userSurname {
                let oldCanSubmit = canSubmit
                surNameIsValidFormat = validateSurNameFormat(userSurname)
                if canSubmit != oldCanSubmit {
                    viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var surNameIsValidFormat: Bool = false
    
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
        return emailIsValidFormat && passwordIsValidFormat && nameIsValidFormat && surNameIsValidFormat
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
    
    fileprivate func validateSurNameFormat(_ surname: String) -> Bool
    {
        let trimmedString = surname.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
                    self.viewDelegate?.notifyUser(self, "Success", "Your Shine account is created.")
                    self.coordinatorDelegate?.emailSignUpViewModelDidCreateAccount(viewModel: self)
                    return
                }
                self.errorMessage = error.localizedDescription
            }
        }
        
        ShineNetworkService.API.createAccountWithEmail(name: self.userName, surName: self.userSurname,
                                                     email: self.email,
                                                     password: self.password,
                                                     mainThreadCompletionHandler: modelCompletionHandler)
        
        
    }
}
