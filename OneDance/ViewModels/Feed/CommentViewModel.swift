//
//  CommentViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/10/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// Model
protocol PostCommentType {
    var id : String { get set }
    var commenter : UserLiteType? { get set }
    var text : String { get set }
    var commentDate : Date { get set }
}

struct PostComment : PostCommentType {
    
    var id : String
    var commenter : UserLiteType?
    var text : String
    var commentDate : Date
    
    
    init() {
        self.id = ""
        self.commenter = UserLite()
        self.text = ""
        self.commentDate = Date()
    }
    
    init(commentId: String, commenter: UserLiteType, text: String, commentDate: Date) {
        self.id = commentId
        self.commenter = commenter
        self.text = text
        self.commentDate = commentDate
    }
}

extension PostComment{
    
    init?(json: [String:Any]) {
        
        guard let commentId = json["id"] as? String, let commentOwner = json["commenter"] as? [String:Any] else {
            
            assertionFailure("Comment with no id")
            return nil
        }
        
        self.id = commentId
        
        if let commentText = json["text"] as? String {
            self.text = commentText
        } else {
            self.text = ""
        }
        
        self.commenter = UserLite(json: commentOwner)

        
        if let date = json["commentDate"] as? Int{
            self.commentDate = Date(timeIntervalSince1970: TimeInterval(date / 1000))
        } else {
            self.commentDate = Date()
        }
        
    }
    
}

extension PostComment : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        
        let commenterUser = self.commenter as? JSONDecodable
        
        return [
            "id" : self.id,
            "commenter" : commenterUser?.jsonData ?? [String:Any](),
            "text": self.text,
            "commentDate":Int(((self.commentDate.timeIntervalSince1970) * 1000).rounded())
        ]
    }
}




protocol PageableCommentListModelType : PageableModel, CommentListModelType { }

struct CommentListModel : PageableCommentListModelType{
    
    var items : [PostCommentType] = [PostComment]()
    var nextPageKey : String = ""
    
    init?(json:[String:Any]) {
        
        if let comments = json["postComments"] as? [[String:Any]], !comments.isEmpty{
            for comment in comments {
                if let commentObj = PostComment(json: comment) {
                    self.items.append(commentObj)
                }
                
            }
        } else {
            return nil
        }
        
        if let key = json["nextPageKey"] as? String {
            self.nextPageKey = key
        }
        
    }
    
    var count : Int {
        get{
            return self.items.isEmpty ? 0 : self.items.count
        }
    }
}

// ============
// Viewmodel
// ============

protocol CommentListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel:CommentListViewModelType)
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
    
    
    func loadItems(refresh: Bool = false){
        
        let completionHandler = {(error: NSError?, userListModel: PageableCommentListModelType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = userListModel {
                        
                        if refresh { self.model = model } //Refresh
                        else { // Fetch
                            for comment in model.items {
                                
                                let hasIt = self.model?.items.contains { item in
                                    
                                    if comment.id == item.id { return true }
                                    else { return false }
                                    
                                }
                                
                                if hasIt != nil && !hasIt!{ self.model?.items.append(comment) }
                                
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
        
        //ShineNetworkService.API.Common.getUserList(source: self.source, type: self.type, sourceId: self.sourceId, nextPageKey: self.model?.nextPageKey ?? "", mainThreadCompletionHandler: completionHandler)
        
        
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

