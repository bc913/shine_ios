//
//  UserListViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/17/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

protocol UserListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel: UserListViewModelType)
}

protocol UserListViewModelCoordinatorDelegate : class {
    
}

typealias UserListVMCoordinatorDelegate = UserListViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol UserListViewModelType {
    
    weak var coordinatorDelegate : UserListVMCoordinatorDelegate? { get set }
    weak var viewDelegate : UserListViewModelViewDelegate? { get set }
    
    var model : PageableUserListModelType? { get set }
    var type : ListType { get set }
    var source : ListSource { get set }
    var sourceId : String { get set }
    
    var count : Int { get }
    func itemAtIndex(_ index: Int) -> UserLiteType?
    
    var title : String { get set }
    
    func requestUserProfile(id: String)
    func requestOrganizationProfile(id: String)
    
    
}

protocol PageableUserListViewModel : class, UserListViewModelType, PageableViewModel, Refreshable, NavigationalViewModel {}

class UserListViewModel : PageableUserListViewModel{
    
    weak var coordinatorDelegate: UserListVMCoordinatorDelegate?
    weak var viewDelegate: UserListViewModelViewDelegate?
    
    var model : PageableUserListModelType?
    
    /// Reason for the user list
    var type : ListType
    var source : ListSource
    
    /// Id based on source
    /// source == postLike ==> postId
    var sourceId : String
    
    var title: String
    
    
    init(type: ListType, source: ListSource, sourceId: String) {
        self.type = type
        self.source = source
        self.sourceId = sourceId
        
        if type == .comment {
            self.title = "Comments"
        } else if type == .like {
            self.title = "Likes"
        } else if type == .follower {
            self.title = "Followers"
        } else if type == .following {
            self.title = "Following"
        } else if type == .interested {
            self.title = "Interested"
        } else if type == .going {
            self.title = "Going"
        } else if type == .notGoing{
            self.title = "Not Going"
        } else {
            self.title = "List"
        }
    }
    
    
    
    // Error
    var errorMessage: String = ""
    
    // List
    var count : Int {
        return model != nil ? model!.count : 0
    }
    
    func itemAtIndex(_ index: Int) -> UserLiteType?{
        
        if self.model != nil && self.model!.count > 0 {
            return self.model!.items[index]
        } else {
            return nil
        }
    }
    
    // PAge
    func refresh() {
        self.model?.nextPageKey = ""
        self.loadItems(refresh: true)
    }
    var shouldShowLoadingCell: Bool = false
    
    func fetchNextPage() {
        self.loadItems()
    }
    
    func loadItems(refresh: Bool = false){
        
        let completionHandler = {(error: NSError?, userListModel: PageableUserListModelType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = userListModel {
                        
                        if refresh { self.model = model } //Refresh
                        else { // Fetch
                            for user in model.items {
                                
                                let hasIt = self.model?.items.contains { item in
                                    
                                    if user.userId == item.userId { return true }
                                    else { return false }
                                    
                                }
                                
                                if hasIt != nil && !hasIt!{ self.model?.items.append(user) }
                                
                            }//for
                            
                            self.model?.nextPageKey = model.nextPageKey
                        }
                        
                    }
                    
                    let hasKey = self.model == nil || (self.model != nil && self.model!.nextPageKey.isEmpty) ? false : true
                    self.shouldShowLoadingCell = hasKey
                    self.viewDelegate?.viewModelDidFinishUpdate(viewModel: self)
                    return
                    
                }
                
                self.errorMessage = error.localizedDescription
                
            }
            
            
        }
        
        ShineNetworkService.API.Common.getUserList(source: self.source, type: self.type, sourceId: self.sourceId, nextPageKey: self.model?.nextPageKey ?? "", mainThreadCompletionHandler: completionHandler)
        
        
    }
    
    func goBack(){
        self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: .viewOnly)
    }
    
    func requestUserProfile(id: String) {
        self.coordinatorDelegate?.viewModelDidSelectUserProfile(userID: id, requestedMode: .viewOnly)
    }
    
    func requestOrganizationProfile(id: String) {
        self.coordinatorDelegate?.viewModelDidSelectOrganizationProfile(organizationID: id, requestedMode: .viewOnly)
    }
    
}
