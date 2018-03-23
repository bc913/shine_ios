//
//  LoginViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/22/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

protocol LoginViewModelCoordinatorDelegate : class {
    func userDidLogin(viewModel: LoginViewModelType)
}

protocol LoginViewModelViewDelegate : class {
    func canSubmitStatusDidChange(_ viewModel: LoginViewModelType, status: Bool)
    func notifyUser(_ viewModel: LoginViewModelType, _ title: String, _ message: String)
}

typealias LoginVMCoordinatorDelegate = LoginViewModelCoordinatorDelegate & AuthChildViewModelCoordinatorDelegate

protocol LoginViewModelType : class, NavigationalViewModel {
    
    // Delegates
    weak var coordinatorDelegate : LoginVMCoordinatorDelegate? { get set }
    weak var viewDelegate : LoginViewModelViewDelegate? { get set }
    
    var email : String? { get set }
    var username : String? { get set }
    var password : String { get set }
    
    var canSubmit : Bool { get }
    var errorMessage : String { get }
    
    func submit()
    
}

class LoginViewModel : LoginViewModelType {
    
    weak var coordinatorDelegate: LoginVMCoordinatorDelegate?
    weak var viewDelegate: LoginViewModelViewDelegate?
    
    /// Email
    var email: String? = "" {
        didSet {
            if email != nil && oldValue != email {
                let oldCanSubmit = canSubmit
                emailIsValidFormat = validateEmailFormat(email!)
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
    
    /// Username
    var username : String? = ""
    
    /// canSubmit
    var canSubmit: Bool {
        if username == nil {
            return emailIsValidFormat && passwordIsValidFormat
        } else {
            return passwordIsValidFormat
        }
    }
    
    /// Errors
    fileprivate(set) var errorMessage: String = "" {
        didSet {
            if oldValue != errorMessage {
                viewDelegate?.notifyUser(self, "Error", errorMessage)
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
        
        let modelCompletionHandler = { (error: NSError?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    print("Persistance userId: \(String(describing: PersistanceManager.User.userId))")
                    print("Persistance secretId: \(String(describing: PersistanceManager.User.secretId))")
                    self.coordinatorDelegate?.viewModelDidCompleteLogin()
                    return
                }
                self.errorMessage = error.localizedDescription
                self.viewDelegate?.notifyUser(self, "Error", self.errorMessage)
            }
        }
        
        let loginModel : LoginModel? = LoginModel(username: self.username, email: self.email, password: self.password)
        ShineNetworkService.API.User.loginUserWith( model:loginModel!, mainThreadCompletionHandler: modelCompletionHandler)
        
    }
    
    
}

extension LoginViewModel {
    func goBack() {
        self.coordinatorDelegate?.viewModelDidSelectGoBack()
    }
}
