//
//  ProfileInfoSetupViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/25/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class ProfileInfoSetupViewModel: ProfileInfoSetupViewModelType {
    weak var coordinatorDelegate: ProfileInfoSetupViewModelCoordinatorDelegate?
    weak var viewDelegate: ProfileInfoSetupViewModelViewDelegate?
    
    var userName: String = "" {
        didSet{
            if oldValue != userName{
                let oldCanSubmit = canSubmit
                userNameIsValid = validateUserName(userName)
                if canSubmit != oldCanSubmit {
                    //viewDelegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    fileprivate var userNameIsValid = false
    
    func validateUserName(_ userName: String) -> Bool {
        
        let trimmedString = userName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString.characters.count > 1
    }
    
    var slogan: String = ""
    var link : String = ""
    
    var canSubmit : Bool {
        return userNameIsValid
    }
    
    fileprivate(set) var errorMessage: String = ""
    
    func submit() {
        print("ProfileInfoSetupVM :: submit()")
        
        let modelCompletionHandler = { (error: NSError?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.coordinatorDelegate?.userDidFinishProfileSetup(viewModel: self)
                    return
                }
                self.errorMessage = error.localizedDescription
            }
        }
        
        ShineNetworkService.API.updateProfileWith(userName: self.userName, slogan: self.slogan, link: self.link, mainThreadCompletionHandler: modelCompletionHandler)
        
        
    }
}

