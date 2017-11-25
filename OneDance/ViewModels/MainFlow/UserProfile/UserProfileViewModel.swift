//
//  UserProfileViewModel.swift
//  OneDance
//
//  Created by Burak Can on 11/2/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class UserProfileViewModel : UserProfileViewModelType {
    
    
    weak var coordinatorDelegate: UserProfileViewModelCoordinatorDelegate?
    weak var viewDelegate: UserProfileViewModelViewDelegate?
    
    var userName: String = ""
    var fullName: String = ""
    var slogan: String = ""
    var bioLink: String = ""
    
    var photUrl: String = ""
    
    var followerCounter: String = ""
    var followingCounter: String = ""
    
    var model : UserProfileModelType? {
        didSet{
            
            self.userName = model?.userName ?? ""
            self.fullName = model?.fullName ?? ""
            self.bioLink = model?.bioLink ?? ""
            self.slogan = model?.slogan ?? ""
            
            self.photUrl = model?.profilePhotoUrl ?? ""
            
            self.followerCounter = model?.followerCounter ?? ""
            self.followingCounter = model?.followingCounter ?? ""
        }
    }
    
    fileprivate(set) var errorMessage: String = ""
    
    func fetch() {
        let modelCompletionHandler = { (error: NSError?, userModel:UserProfileModelType?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.model = userModel
                    self.viewDelegate?.viewModelDidFetchUserProfile(viewModel: self)
                    return
                }
                self.model = nil
                self.errorMessage = error.localizedDescription
            }
            
        }
        
        ShineNetworkService.API.User.getMyProfile(mainThreadCompletionHandler: modelCompletionHandler)
    }
    
    
    init() {
        self.fetch()
        
    }
    
    
    
    
}
