//
//  TimeLineViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


//==================
// Post Detail
//==================

protocol PostDetailType {
    var id : String { get set }
    var repostedPostId : String { get set }
    
    var text : String { get set }
    
    var media : ImageType? { get set }
    
    var owner : UserLiteType? { get set }
    var location : LocationLiteType? { get set }
    var organization : OrganizationLiteType? { get set }
    
    var likeCounter : Int { get set }
    var commentCounter : Int { get set }
    
    var dateCreated : Date? { get set }
}

struct PostDetail : PostDetailType{
    var id : String = ""
    var repostedPostId : String = ""
    
    /// Post description
    var text : String = ""
    
    var media : ImageType?
    
    var owner : UserLiteType?
    var location : LocationLiteType?
    var organization : OrganizationLiteType?
    
    var likeCounter : Int = 0
    var commentCounter : Int = 0
    
    var dateCreated : Date?
    
    init() { }
    
    init?(json: [String:Any]){
        
        guard let id = json["id"] as? String else {
            assert(true, "Post detail initialization failed")
            return nil
        }
        
        self.id = id
        
        if let repostId = json["repostedPostId"] as? String {
            self.repostedPostId = repostId
        }
        
        if let postText = json["text"] as? String{
            self.text = postText
        }
        
        if let media = json["media"] as? [String:Any], let isImage = media["image"] as? Bool, isImage == true {
            self.media = MediaImage(json: media)
        }
        
        if let owner = json["owner"] as? [String:Any] {
            self.owner = UserLite(json: owner)
        }
        
        if let location = json["location"] as? [String:Any] {
            self.location = LocationLite(json: location)!
        }
        
        if let ownerAsOrg = json["organization"] as? [String:Any] {
            self.organization = OrganizationLite(json: ownerAsOrg)
        }
        
        if let likes = json["likes"] as? Int {
            self.likeCounter = likes
        }
        
        if let comments = json["comments"] as? Int {
            self.commentCounter = comments
        }
        
        if let createdUnixTime = json["created"] as? Int {
            self.dateCreated = Date(timeIntervalSince1970: TimeInterval(createdUnixTime / 1000))
        }
    }
    
    
}

extension PostDetail : JSONDecodable {
    
    var jsonData : [String:Any]{
        
        let mediaInfo = self.media as? JSONDecodable
        let loc = self.location as? JSONDecodable
        let userOwner = self.owner as? JSONDecodable
        let organizationOwner = self.organization as? JSONDecodable
        
        return[
            "id": self.id,
            "repostedPostId": self.repostedPostId,
            "text": self.text,
            "media": mediaInfo?.jsonData ?? [String:Any](),
            "owner": userOwner?.jsonData ?? [String:Any](),
            "location": loc?.jsonData ?? [String:Any](),
            "organization": organizationOwner?.jsonData ?? [String:Any](),
            "likes": self.likeCounter,
            "comments": self.commentCounter,
            "created": self.dateCreated != nil ? Int(((self.dateCreated!.timeIntervalSince1970) * 1000).rounded()) : 0,
        ]
        
    }
    
}

//==================
// Feed Item
//==================

struct Feed {
    var post : PostDetailType = PostDetail()
    init() {
    }
    
    init(postDetail: PostDetailType) {
        self.post = postDetail
    }
    
    init?(json:[String:Any]) {
        guard let postDetail = json["post"] as? [String:Any] else { return nil }
        self.post = PostDetail(json: postDetail)!
    }
    
    // Convenience properties
    var username : String {
        get{
            return self.post.owner?.userName ?? "Undefined"
        }
    }
    
    var date : Date {
        get{
            return self.post.dateCreated ?? Date()
        }
    }
    
    var text : String {
        get {
            return self.post.text
        }
    }
    
    var profilePhotoUrl : String {
        get{
            
            let url = self.post.owner?.profilePhoto?.thumbnail?.url?.absoluteString
            return url ?? ""
        }
    }
    
    var locationName : String {
        get{
            return self.post.location?.name ?? ""
        }
    }
    
    var location : LocationLite?{
        get{
            return self.post.location as? LocationLite
        }
    }
    
    var hasPostMedia : Bool {
        get{
            
            return self.post.media != nil && self.post.media!.id != nil && self.post.media!.id!.isEmpty
        }
    }
    
    var postMediaUrl : String {
        get{
            let url = self.post.media?.standard?.url?.absoluteString
            return url ?? ""
        }
    }
    
    var id : String {
        get{
            return self.post.id
        }
        
    }
    
    var commentCounter : Int {
        get{
            return self.post.commentCounter
        }
    }
    
    var likeCounter : Int {
        get {
            return self.post.likeCounter
        }
    }
    
    var ownerId : String{
        get {
            return self.post.owner?.userId ?? self.post.organization?.id ?? ""
        }
    }    
    
}

extension Feed : JSONDecodable {
    var jsonData : [String:Any] {
        
        let postDetail = self.post as? JSONDecodable
        
        /// TODO: Update this code
        let dummyDate = Date()
        
        return [
            "post": postDetail?.jsonData ?? [String:Any](),
            "date": Int(((dummyDate.timeIntervalSince1970) * 1000).rounded()),
            "feedType": "dummy",
            "event": [String:Any](),
            "originatorUser": [String:Any](),
            "originatorOrganization" : [String:Any](),
            "comment": "No Comment"
        ]
    }
}

struct FeedListModel {
    
    var feedItems = [Feed]()
    var nextPageKey : String = ""
    
    init() {
        
    }
    
    init?(json:[String:Any]) {
        
        if let feeds = json["feedItems"] as? [[String:Any]], !feeds.isEmpty {
            for feed in feeds {
                self.feedItems.append(Feed(json:feed)!)
            }
        }
        
        if let key = json["nextPageKey"] as? String {
            self.nextPageKey = key
        }
    }
}

//============
//
//============




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
