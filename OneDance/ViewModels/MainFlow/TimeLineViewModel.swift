//
//  TimeLineViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


typealias TimeLineVMCoordinatorDelegate = TimeLineViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol TimeLineViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel: TimeLineViewModelType)
}

protocol TimeLineViewModelCoordinatorDelegate : class {
    
    func viewModelDidSelectCreateEvent(viewModel: TimeLineViewModelType)
    func viewModelDidSelectCreateOrganization(viewModel: TimeLineViewModelType)
    
    
    // Handle the refresh inside viewModel and update viewDelegate
}

protocol ListableViewModel {
    func requestList(of type: ListType, source: ListSource, id: String)
}

protocol TimeLineViewModelType : class, ListableViewModel {
    
    weak var coordinatorDelegate : TimeLineVMCoordinatorDelegate? { get set }
    weak var viewDelegate : TimeLineViewModelViewDelegate? { get set }
    
    func createOrganization()
    func createEvent()
    func createPost()
    
    var errorMessage : String { get set }
    
    //
    func itemAtIndex(_ index: Int) -> Feed?
    var count : Int { get }
    
    var shouldShowLoadingCell : Bool { get set }
    func refreshItems()
    func fetchNextPage()
    
    func requestUserProfile(id: String)
    func requestOrganizationProfile(id: String)
    func requestLocationDetail(id: String, type: ShineLocationDetailType)
    
    func likePost(id: String)
    func removeLikeFromPost(id:String)
    
    
}

class TimeLineViewModel : TimeLineViewModelType {
    
    weak var coordinatorDelegate: TimeLineVMCoordinatorDelegate? {
        didSet{
            print("TimelineCoordinatorDelagate::Didset")
        }
    }
    weak var viewDelegate: TimeLineViewModelViewDelegate?
    
    // Error
    var errorMessage: String = ""
    
    // Model
    var feedListModel = FeedListModel() {
        didSet{
            print("listmodel set count: \(self.count)")
        }
    }
    var currentPage : Int = 1
    var shouldShowLoadingCell: Bool = false
    
    func refreshItems() {
        self.currentPage = 1
        self.feedListModel.nextPageKey = ""
        self.loadItems(refresh: true)
    }
    
    func fetchNextPage() {
        self.currentPage += 1
        self.loadItems()
    }
    
    func loadItems(refresh: Bool = false){
        let modelCompletionHandler = {(error: NSError?, feedListModel: FeedListModel?) in
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = feedListModel {
                        
                        if refresh {// Refresh
                            self.feedListModel = model
                        }else { // Fetch
                            
                            
                            for feed in model.feedItems{
                                let hasIt = self.feedListModel.feedItems.contains { item in
                                    
                                    if feed.id == item.id { return true }
                                    else { return false }
                                }
                                
                                if !hasIt {
                                    self.feedListModel.feedItems.append(feed)
                                }
                            }
                            
                            self.feedListModel.nextPageKey = model.nextPageKey
                            
                        }
                    }
                    
                    self.shouldShowLoadingCell = self.feedListModel.nextPageKey.isEmpty ? false : true
                    self.viewDelegate?.viewModelDidFinishUpdate(viewModel: self)
                    return
                }
                
                self.errorMessage = error.localizedDescription
            }
        }
        
        ShineNetworkService.API.Feed.getMyFeed(nextPageKey: self.feedListModel.nextPageKey, refresh: refresh, mainThreadCompletionHandler: modelCompletionHandler)
    }
    
    var count: Int {
        return self.feedListModel.feedItems.count
    }
    
    func itemAtIndex(_ index: Int) -> Feed? {
        if !self.feedListModel.feedItems.isEmpty && self.count > index {
            return self.feedListModel.feedItems[index]
        } else {
            return nil
        }
    }
    
    func createOrganization() {
        self.coordinatorDelegate?.viewModelDidSelectOrganizationProfile(organizationID: "", requestedMode: .create)
        
    }
    
    func createEvent() {
        self.coordinatorDelegate?.viewModelDidSelectEvent(eventID: "", requestedMode: .create)
    }
    
    func createPost(){
        self.coordinatorDelegate?.viewModelDidSelectPost(postID: "", requestedMode: .create)
    }
    
    func requestList(of type: ListType, source: ListSource,  id: String) {
        print("Comment tapped for id: \(id)")
        self.coordinatorDelegate?.viewModelDidSelectList(id: id, type: type, source: source)
        return
    }
    
    func requestUserProfile(id: String) {
        self.coordinatorDelegate?.viewModelDidSelectUserProfile(userID: id, requestedMode: .viewOnly)
    }
    
    func requestOrganizationProfile(id: String) {
        self.coordinatorDelegate?.viewModelDidSelectOrganizationProfile(organizationID: id, requestedMode: .viewOnly)
    }
    
    func requestLocationDetail(id: String, type: ShineLocationDetailType) {
        self.coordinatorDelegate?.viewModelDidSelectLocation(locId: id, detailType: type, requestedMode: .viewOnly)
    }
    
    func likePost(id: String){
        ShineNetworkService.API.Feed.likePost(postId: id)
    }
    
    func removeLikeFromPost(id: String) {
        ShineNetworkService.API.Feed.removeLikeFromPost(postId: id)
    }
    
    
    
}
