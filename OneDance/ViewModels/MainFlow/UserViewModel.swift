//
//  UserViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/19/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol UserViewModelCoordinatorDelegate : class {
    
}

protocol UserViewModelViewDelegate : class {
    
}

class UserViewModel {
    
    // UserViewModel can only be in view only mode.
    
    weak var coordinatorDelegate : UserViewModelCoordinatorDelegate?
    weak var viewDelegate : UserViewModelViewDelegate?
    
    var mode : ShineMode = .viewOnly
    var model : UserModelType?
    
    
    // Properties
    var id : String
    var username : String = ""
    var fullname : String = ""
    
    var email : String = ""
    var postsCounter : Int?
    var isAccountPrivate : Bool = false
    
    var followerCounter : Int?
    var followingCounter : Int?
    
    // TODO :Image
    var bio : String?
    var websiteUrl : String?
    
    var danceTypes : [DanceTypeItem]?
    
    var djProfile : DJProfileItem?
    var instructorProfile : InstructorProfileItem?
    
    // Ctors
    init(mode: ShineMode, id: String) {
        self.mode = mode
        self.id = id
        
        self.fetchModelData()
    }
    
    
    
    // Model Update
    func updateModel() {
        
    }
    
    
    
    // View Model Update
    func populateViewModel(){
        
        self.username = self.model?.userName ?? ""
        self.fullname = self.model?.fullName ?? ""
        self.email = self.model?.email ?? ""
        
        self.postsCounter = self.model?.postsCounter
        self.isAccountPrivate = self.model?.isPrivateAccount ?? false
        
        self.followingCounter = self.model?.followingCounter
        self.followerCounter = self.model?.followerCounter
        
        self.bio = self.model?.bio
        self.websiteUrl = self.model?.websiteUrl
        
        // Favorite dances
        // Dance types
        if let modelDances = self.model?.danceTypes, !modelDances.isEmpty {
            
            if self.danceTypes == nil {
                self.danceTypes = [DanceTypeItem]()
                self.danceTypes?.reserveCapacity(modelDances.count)
            } else {
                self.danceTypes?.removeAll()
            }
            
            for dance in modelDances {
                if let danceObj = dance as? DanceType {
                    self.danceTypes?.append(DanceTypeItem(danceTypeModel: danceObj))
                }
            }
        } else {
            self.danceTypes = nil
        }
        
        if let dj = self.model?.djProfile {
            self.djProfile = DJProfileItem(model: dj)
        } else {
            self.djProfile = nil
        }
        
        if let instructor = self.model?.instructorProfile {
            self.instructorProfile = InstructorProfileItem(model: instructor)
        } else {
            self.instructorProfile = nil
        }
        
        
    }
    
    
    // Fetch model data
    private func fetchModelData(){
        
        let modelCompletionHandler = { (error: NSError?, model:UserModel?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.model = model
                    // Populate view Model
                    return
                }
                self.model = nil
                //self.errorMessage = error.localizedDescription
                
            }
            
        }
    }
    
    // Actions
    
    func updateProfile(){
        // Check if the user tries the edit his/her profile
    }
    
    func messageUser(){
        // Send message to a user
    }
    
    func viewUsersPosts(){}
    func viewUsersMedia(){}
    func viewUsersEvents(){} // ????
    
    // ChildEvents
    func viewEventDetail(){}
    func viewOrganizationDetail(){}
    func viewUserProfile(){}
    
    
    
}
