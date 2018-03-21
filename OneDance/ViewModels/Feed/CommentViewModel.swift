//
//  CommentViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/10/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// ============
// Viewmodel
// ============

protocol CommentListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel:CommentListViewModelType)
    func viewModelDidFinishAddingNewComment(viewModel: CommentListViewModelType)
}

protocol CommentListViewModelCoordinatorDelegate : class{
    
}

typealias CommentListVMCoordinatorDelegate = CommentListViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol CommentListViewModelType {
    
    weak var viewDelegate : CommentListViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : CommentListVMCoordinatorDelegate? { get set }
    
    
    var sourceId: String { get set }
    var model : PageableCommentListModelType? { get set }
    
    
    var count : Int { get }
    func itemAtIndex(_ index: Int) -> PostCommentType?
    
    var title : String { get set }
    
    
    func goBack()
    
    func requestUserProfile(id: String)
    func requestOrganizationProfile(id: String)
    
    func addNewComment(commentText: String)
    
}

protocol PageableCommentListViewModelType : class, CommentListViewModelType, Refreshable, PageableViewModel, NavigationalViewModel {
    
}

class CommentListViewModel : PageableCommentListViewModelType{
    
    weak var viewDelegate : CommentListViewModelViewDelegate?
    weak var coordinatorDelegate : CommentListVMCoordinatorDelegate?
    
    var sourceId : String
    var model : PageableCommentListModelType?
    
    init(sourceId: String, source: ListSource = .post, type: ListType = .comment) {
        self.sourceId = sourceId
        
        self.source = source
        self.type = type
    }
    
    var source : ListSource = .post
    var type : ListType = .comment
    
    var title : String = "Comments"
    var errorMessage : String = ""
    
    // List
    var count : Int {
        return model != nil ? model!.count : 0
    }
    
    func itemAtIndex(_ index: Int) -> PostCommentType?{
        
        if self.model != nil && self.model!.count > 0 {
            return self.model!.items[index]
        } else {
            return nil
        }
    }
    
    // Refresh
    func refresh() {
        self.model?.nextPageKey = ""
        self.loadItems(refresh: true)
    }
    
    // Pageable
    var shouldShowLoadingCell: Bool = false
    
    func fetchNextPage() {
        self.loadItems()
    }
    
    
    func loadItems(refresh: Bool = false, newCommentAdded: Bool = false){
        
        let completionHandler = {(error: NSError?, commentListModel: PageableCommentListModelType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = commentListModel, model.count > 0 {
                        
                        if refresh { self.model = model } //Refresh
                        else { // Fetch
                            
                            if self.model == nil {
                                self.model = model
                            }
                            
                            for comment in model.items {
                                
                                let hasIt = self.model?.items.contains { item in
                                    
                                    if comment.id == item.id { return true }
                                    else { return false }
                                    
                                }
                                
                                if hasIt != nil && !hasIt!{
                                    if newCommentAdded {
                                        self.model?.items.insert(comment, at: 0)
                                    } else {
                                        self.model?.items.append(comment)
                                    }
                                }
                                
                            }//for
                            
                            self.model?.nextPageKey = model.nextPageKey
                        }
                        
                    } else {
                        self.model = nil
                    }
                    
                    let hasKey = self.model == nil || (self.model != nil && self.model!.nextPageKey.isEmpty) ? false : true
                    self.shouldShowLoadingCell = hasKey
                    self.viewDelegate?.viewModelDidFinishUpdate(viewModel: self)
                    return
                    
                }
                
                self.errorMessage = error.localizedDescription
                
            }
            
            
        }
        
        ShineNetworkService.API.Feed.getPostComments(postID: self.source == .post && self.type == .comment ? self.sourceId : "", nextPageKey: self.model?.nextPageKey ?? "", mainThreadCompletionHandler: completionHandler)
                
        
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
    
    func addNewComment(commentText: String) {
        
        let modelCompletionHandler = {(error: NSError?, addedComment: PostCommentType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    self.loadItems(refresh: false, newCommentAdded: true)
                    self.viewDelegate?.viewModelDidFinishAddingNewComment(viewModel: self)
                    return
                    
//                    if self.model != nil && addedComment != nil{
//                        
//                        for comment in self.model!.items {
//                            
//                            let hasIt = self.model?.items.contains { item in
//                                
//                                if addedComment!.id == item.id { return true }
//                                else { return false }
//                            }
//                            
//                            if hasIt != nil && !hasIt!{ self.model?.items.append(comment) }
//                        }
//                        
//                        self.viewDelegate?.viewModelDidFinishAddingNewComment(viewModel: self)
//                        return
//                    } else if self.model == nil && addedComment != nil {
//                        
//                        self.model = CommentListModel()
//                        self.model?.items.append(addedComment!)
//                        self.viewDelegate?.viewModelDidFinishAddingNewComment(viewModel: self)
//                        return
//                    } else { return }
                }
                
                self.errorMessage = error.localizedDescription
                
            }
            
        }
        
        if !commentText.isEmpty {
            ShineNetworkService.API.Feed.addCommentForPost(id: self.source == .post && self.type == .comment ? self.sourceId : "", comment: commentText, mainThreadCompletionHandler: modelCompletionHandler)
        }
        
    }

    
    
}

