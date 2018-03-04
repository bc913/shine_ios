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
    
    func viewModelDidFetchUserProfile(viewModel: UserViewModelType)
}

typealias UserVMCoordinatorDelegate = UserViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol UserViewModelType : class {
    
    weak var coordinatorDelegate : UserVMCoordinatorDelegate? { get set }
    weak var viewDelegate : UserViewModelViewDelegate? { get set }
    var isMyProfile : Bool { get }
    
    var mode : ShineMode { get set }
    var model : UserModelType? { get set }
    
    var id : String { get set }
    var username : String { get set }
    var fullname : String { get set }
    
    var email : String { get set }
    var postsCounter : Int? { get set }
    var isAccountPrivate : Bool { get set }
    
    var followerCounter : Int? { get set }
    var followingCounter : Int? { get set }
    
    var bio : String? { get set }
    var websiteUrl : String? { get set }
    
    var danceTypes : [DanceTypeItem]? { get set }
    var djProfile : DJProfileItem? { get set }
    var instructorProfile : InstructorProfileItem? { get set }
    
    // Actions
    func doneEditing()
    func cancelEditing()
    func requestEditing()
    
}

class UserViewModel : UserViewModelType{
    
    // UserViewModel can only be in view only mode.
    
    weak var coordinatorDelegate : UserVMCoordinatorDelegate?
    weak var viewDelegate : UserViewModelViewDelegate?
    
    var isMyProfile : Bool {
        get{
            return id == PersistanceManager.User.userId!
        }
    }
    
    
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
    init(mode: ShineMode, id: String = "") {
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
        
        let modelCompletionHandler = { (error: NSError?, model:UserModelType?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.model = model
                    self.populateViewModel()
                    self.viewDelegate?.viewModelDidFetchUserProfile(viewModel: self)
                    return
                }
                self.model = nil
                //self.errorMessage = error.localizedDescription
                
            }
            
        }
        
        if self.isMyProfile {
            ShineNetworkService.API.User.getMyProfile(mainThreadCompletionHandler: modelCompletionHandler)
        } else {
            ShineNetworkService.API.User.getUserProfile(otherUserId: self.id, mainThreadCompletionHandler: modelCompletionHandler)
        }
        
    }
    
    // Actions
    
    func doneEditing() {
        
        
        
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
    }
    
    func cancelEditing() {
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
    }
    
    func requestEditing(){
        self.coordinatorDelegate?.viewModelDidSelectUserProfile(userID: self.id, requestedMode: .edit)
    }
    
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
