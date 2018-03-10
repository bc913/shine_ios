//
//  HomeScreenContainerCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

enum ListSource {
    
    case user
    case organization
    case post
    case event
}

enum ListType{
    
    case like
    case eventAttendance
    case interested
    case notGoing
    case going
    case comment
    
    case follower
    case following
}

enum NotificationType{
    
    case updateEvent
    case createEvent
}

protocol Modeable {
    var mode : ShineMode { get set }
}

//=======================
//MARK: ChildCoordinators
//MARK:=======================

// Every parent coordinator shoul conform this
protocol ChildCoordinatorDelegate : class {
    
    // LIST
    // User request organization follower list
    // User request user follower list
    // User reques user following list
    // User request a post's liker list
    // User request event attendance/interested/not going list
    
    func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, type: ListType, source: ListSource )
    
    // User request an organization's post list
    // User request another user's post list
    
    // User request a post's comment list
    
    // User request other djs/instructors event list
    // A dance type is selected and show related events and organization around the user
    //func childCoordinatorDidRequestADanceTypeEventList(sender:BaseChildCoordinator, type: IDanceType, id: String)
    
    
    // EVENT
    func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // ORGANIZATION
    // User request an organization's detail
    func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // USER
    func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // POST
    // regular, uploadPhotoOnly, likes or follows
    // USer request a post's detail
    func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // MEDIA
    
    // Notify timeline
    //func childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
    
    
    // OPERATION
    func childCoordinatorDidFinishOperation(from sender: BaseChildCoordinator, for mode: ShineMode)
    
    // GO BACK
    func childCoordinatorDidRequestGoBack(sender: BaseChildCoordinator, mode: ShineMode)
    
}

/// Base class definitions for all child coordinators under container coordinator.
/// Every child coordinator should inherit this.

protocol BaseChildCoordinatorType : class {
    weak var delegate : ChildCoordinatorDelegate? { get set }
    var id : String { get set }
    var hostNavigationController : UINavigationController { get set }
}

class BaseChildCoordinator {
    
    weak var delegate : ChildCoordinatorDelegate? // Container coordinator
    var id : String
    var hostNavigationController : UINavigationController
    
    init(host: UINavigationController, id: String) {
        self.hostNavigationController = host
        self.id = id
    }
    
    func equals(another: BaseChildCoordinator) -> Bool{
        return self === another
    }
}

protocol ChildViewModelCoordinatorDelegate : class {
    
    func viewModelDidSelectUserProfile(userID: String, requestedMode: ShineMode )
    func viewModelDidSelectOrganizationProfile(organizationID: String, requestedMode: ShineMode)
    func viewModelDidSelectEvent(eventID: String, requestedMode: ShineMode)
    func viewModelDidSelectList(id: String, type: ListType, source: ListSource)
    func viewModelDidSelectPost(postID: String, requestedMode: ShineMode)
    func viewModelDidFinishOperation(mode: ShineMode)
    func viewModelDidSelectGoBack(mode: ShineMode)
}

/// coordinator delegate of every child view model has this
extension BaseChildCoordinator : ChildViewModelCoordinatorDelegate {
    
    // User
    func viewModelDidSelectUserProfile(userID: String, requestedMode: ShineMode ) {
        self.delegate?.childCoordinatorDidRequestUserDetail(sender: self, id: userID, mode: requestedMode)
    }
    // Organization
    func viewModelDidSelectOrganizationProfile(organizationID: String, requestedMode: ShineMode){
        self.delegate?.childCoordinatorDidRequestOrganizationDetail(sender: self, id: organizationID, mode: requestedMode)
    }
    //Event
    func viewModelDidSelectEvent(eventID: String, requestedMode: ShineMode) {
        self.delegate?.childCoordinatorDidRequestEventDetail(sender: self, id: eventID, mode: requestedMode)
    }
    // List
    func viewModelDidSelectList(id: String, type: ListType, source: ListSource){
        self.delegate?.childCoordinatorDidRequestList(sender: self, id: id, type: type, source: source)
    }
    // Post
    func viewModelDidSelectPost(postID: String, requestedMode: ShineMode){
        self.delegate?.childCoordinatorDidRequestPostDetail(sender: self, id: postID, mode: requestedMode)
    }
    
    func viewModelDidFinishOperation(mode: ShineMode) {
        self.delegate?.childCoordinatorDidFinishOperation(from: self, for: mode)
    }
    
    func viewModelDidSelectGoBack(mode: ShineMode) {
        self.delegate?.childCoordinatorDidRequestGoBack(sender: self, mode: mode)
    }
}

//===============================================================================================
//MARK: ContainerCoordinator
//===============================================================================================

class BaseContainerCoordinator {
    
    var childCoordinators = [String: BaseChildCoordinator]()
    var containerNavigationController: UINavigationController
    
    var coordinatorStack : Stack<BaseChildCoordinator> = Stack<BaseChildCoordinator>()
    
    init(containerNavController: UINavigationController) {
        self.containerNavigationController = containerNavController
    }
}

extension BaseContainerCoordinator {
    
    var activeCoordinator : BaseChildCoordinator? {
        return self.coordinatorStack.top
    }
}

extension BaseContainerCoordinator : ChildCoordinatorDelegate {
    
    func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
        
        //        let userCoordinator = UserProfileCoordinator(host: self.containerNavigationController, id: id,mode: mode)
        //        childCoordinators["USER"] = userCoordinator
        //        userCoordinator.delegate = self
        //        userCoordinator.start()
        
        let userProfileCoordinator = UserProfileCoordinator(host: self.containerNavigationController, id: id,mode: mode)
        userProfileCoordinator.delegate = self
        self.coordinatorStack.push(userProfileCoordinator)
        userProfileCoordinator.start()
    }
    
    func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
        let orgCoordinator = OrganizationCoordinator(host: self.containerNavigationController, id: id, mode: mode)
        orgCoordinator.delegate = self
        self.coordinatorStack.push(orgCoordinator)
        orgCoordinator.start()
        
    }
    
    func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
        let eventCoordinator = EventCoordinator(host: self.containerNavigationController, id: id, mode: mode)
        eventCoordinator.delegate = self
        self.coordinatorStack.push(eventCoordinator)
        eventCoordinator.start()
    }
    
    func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, type: ListType, source: ListSource ){
        let listCoordinator = ListCoordinator(host: self.containerNavigationController, id: id, type: type, source:source)
        listCoordinator.delegate = self
        self.coordinatorStack.push(listCoordinator)
        listCoordinator.start()
    }
    
    func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
        let postCoordinator = PostCoordinator(host: self.containerNavigationController, id: id, mode:mode)
        //        childCoordinators["POST"] = postCoordinator
        postCoordinator.delegate = self
        self.coordinatorStack.push(postCoordinator)
        postCoordinator.start()
    }
    
    // Notify container when delete, edit and create operations are done
    func childCoordinatorDidFinishOperation(from: BaseChildCoordinator, for: ShineMode){
        self.containerNavigationController.topViewController?.dismiss(animated: true, completion: nil)
        self.coordinatorStack.pop()
    }
    
    //GO BACK
    func childCoordinatorDidRequestGoBack(sender: BaseChildCoordinator, mode: ShineMode) {
        self.containerNavigationController.popViewController(animated: true)
        self.coordinatorStack.pop()
    }
    
    
}

//===============================================================================================
//MARK: HomeScreenCoordinator
//===============================================================================================

class HomeScreenContainerCoordinator : BaseContainerCoordinator, Coordinator{
  
    
    func start() {
        self.showTimeLine()
    }
    
}
    
extension HomeScreenContainerCoordinator : TimeLineCoordinatorDelegate {
    
    func showTimeLine() {
        
        let timelineCoordinator = TimeLineCoordinator(host: self.containerNavigationController, id: PersistanceManager.User.userId!)
        //childCoordinators["TIMELINE"] = timelineCoordinator
        //activeCoordinator = timelineCoordinator
        
        timelineCoordinator.delegate = self
        self.coordinatorStack.push(timelineCoordinator)
        timelineCoordinator.start()
        
    }
}

//===============================================================================================
//MARK: TimelineCoordinator
//===============================================================================================
// This is the root coordinator of the home screen view

protocol TimeLineCoordinatorDelegate : class {

}

class TimeLineCoordinator : BaseChildCoordinator {
    
}

extension TimeLineCoordinator : Coordinator {
    
    func start() {
        let vc = TimeLineViewController(nibName: "TimeLineViewController", bundle: nil)
        print("TimeLineCoordinator.start()")
        let viewModel = TimeLineViewModel() // it doesn't have mode. It is always view only mode.
        viewModel.coordinatorDelegate = self //typealias TimelineVMCoordinatorDelegate: ChildViewModelCoordinatorDelegate & TimeLineViewModelCoordinatorDelegate
        vc.viewModel = viewModel
        self.hostNavigationController.setViewControllers([vc], animated: false) // It is always root controller
    }
    
}

extension TimeLineCoordinator : TimeLineViewModelCoordinatorDelegate {
    
    func viewModelDidSelectCreateOrganization(viewModel: TimeLineViewModelType) {

    }
    
    func viewModelDidSelectCreateEvent(viewModel: TimeLineViewModelType) {
        print("Create Event")
    }
    
}


//===============================================================================================
//MARK: OrganizationCoordinator
//===============================================================================================
class OrganizationCoordinator : BaseChildCoordinator{
    
    var mode : ShineMode
    
    init(host: UINavigationController, id: String, mode: ShineMode = .viewOnly) {
        self.mode = mode
        //self.viewModel = EventViewModel(mode: self.mode, id: id)
        super.init(host:host, id: id)
    }
    
    override convenience init(host: UINavigationController, id: String) {
        self.init(host:host, id: id, mode: .viewOnly)
    }
}

extension OrganizationCoordinator : Coordinator {
    
    func start() {
        
        if self.mode == .viewOnly
        {
            self.startViewOrganizationDetail()
        }
        else
        {
            self.startCreateEditOrganization()
        }
    }
    
    func startViewOrganizationDetail(){
        /*
        var vc = OrganizationDetailViewController(nibName:"OrganizationDetailViewController", bundle: nil)
        var viewModel = OrganizationViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
        viewModel.coordinatorDelegate = self //typealias OrganizationProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & OrganizationViewModelCoordinatorDelegate
        
        vc.viewModel = viewModel
        self.hostNavigationController.push(viewController: vc, animated: true)
        */
    }
    
    func startCreateEditOrganization(){
        
        let vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
        let viewModel = OrganizationViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
        viewModel.coordinatorDelegate = self //typealias OrganizationProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & OrganizationViewModelCoordinatorDelegate
        
        vc.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: vc)
        self.hostNavigationController.topViewController?.present(navigationController, animated:true)
    }
}


extension OrganizationCoordinator : OrganizationViewModelCoordinatorDelegate {
    
    func viewModelDidRequestEditCreate(viewModel: OrganizationViewModelType) {
        
        self.mode = .edit
        self.startCreateEditOrganization()
    }
    
    func viewModelDidFinishEditCreate(viewModel: OrganizationViewModelType) {
        
        self.mode = .viewOnly
        /*
        // End editing
        if var viewOrgVC = self.hostNavigationController.topViewController as? OrganizationDetailViewController,
            var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateOrganizationViewController
            // var editCreateVC = viewOrgVC.presentedViewController as? EditCreateOrganizationViewController
        {
            viewOrgVC.dismiss(animated: true)
            viewOrgVC.viewModel.refresh() // no need to navigate to the timeline
            return
        }
        */
        // End creating
        if  let editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateOrganizationViewController,
            editCreateVC.viewModel?.mode == .create {
            self.hostNavigationController.topViewController?.dismiss(animated: true)
            // Notify & navigate timeline
            //delegate?.childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
            return
        }
        
        
    }
    
    func viewModelDidCancelEditCreate(viewModel: OrganizationViewModelType) {
        self.mode = .viewOnly
        self.hostNavigationController.topViewController?.dismiss(animated: true)
    }
}

//===============================================================================================
//MARK: EventCoordinator
//MARK:==========================

class EventCoordinator : BaseChildCoordinator {
    var mode : ShineMode
    
    init(host: UINavigationController, id: String, mode: ShineMode = .viewOnly) {
        self.mode = mode
        //self.viewModel = EventViewModel(mode: self.mode, id: id)
        super.init(host:host, id: id)
    }
    
    override convenience init(host: UINavigationController, id: String) {
        self.init(host:host, id: id, mode: .viewOnly)
    }
    
    var locationCoordinator : LocationCoordinator?
    

}

extension EventCoordinator : Coordinator {
    
    func start() {
        if self.mode == .viewOnly {
            self.startViewEventDetail()
        } else{
            self.startCreateEditEvent()
        }
    }
    
    func startViewEventDetail() {
        
    }
    
    func startCreateEditEvent(){
        
        let vc = EditCreateEventViewController(nibName: "EditCreateEventViewController", bundle: nil)
        let viewModel = EventViewModel(mode: self.mode, id: self.id)
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.hostNavigationController.topViewController?.present(navigationController, animated:true)
        
    }
    
}

extension EventCoordinator : EventViewModelCoordinatorDelegate{
    
    func viewModelDidRequestLocation(){
        print("EventCoordinator::vmDidRequestLocation")
        self.locationCoordinator = LocationCoordinator(host: self.hostNavigationController, id: "")
        self.locationCoordinator?.parentCoordinator = self
        self.locationCoordinator?.start()
    }
}

extension EventCoordinator : LocationCoordinatorDelegate{
    func locationCoordinatorDidSelectLocation() {
        // Pass location info to the view model
        print("Lcoation selected")
    }

    
}

//===============================================================================================
//MARK: ListCoordinator
//MARK:==========================

class ListCoordinator : BaseChildCoordinator{
    
    fileprivate var type : ListType
    fileprivate var source :ListSource
    
    init(host: UINavigationController, id: String, type:ListType, source: ListSource) {
        self.type = type
        self.source = source
        super.init(host:host, id: id)
    }
    
}

extension ListCoordinator : Coordinator{
    func start() {
        
        if self.type == .like || self.type == .follower || self.type == .following {
            startUserList()
        } else if self.type == .comment && self.source == .post {
            startPostComments()
        }       
    }
    
    private func startPostComments(){
        
        let vc = ShineCommentListViewController(nibName: "ShineCommentListViewController", bundle: nil)
        let viewModel = CommentListViewModel(sourceId: self.id)
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        
        if self.hostNavigationController.topViewController != nil {
            self.hostNavigationController.topViewController!.hidesBottomBarWhenPushed = true
        }
        
        self.hostNavigationController.pushViewController(vc, animated: true)
        
        // HACK: After pushing comment list, change the hidetabbar property for the presenter here
        let vcCounter = self.hostNavigationController.viewControllers.count
        if vcCounter > 1 {
            self.hostNavigationController.viewControllers[vcCounter - 2].hidesBottomBarWhenPushed = false
        }
        
    }
    
    private func startUserList(){
        let vc = ShineUserListViewController(nibName: nil, bundle: nil)
        let viewModel = UserListViewModel(type: self.type, source: self.source, sourceId: self.id)
        viewModel.coordinatorDelegate = self
        
        vc.viewModel = viewModel
        self.hostNavigationController.pushViewController(vc, animated: true)
    }
}

extension ListCoordinator : UserListViewModelCoordinatorDelegate {}

extension ListCoordinator : CommentListViewModelCoordinatorDelegate {}


//===============================================================================================
//MARK: PostCoordinator
//MARK:==========================
class PostCoordinator : BaseChildCoordinator{
    
    var mode : ShineMode
    
    init(host: UINavigationController, id: String, mode: ShineMode = .create) {
        self.mode = mode
        //self.viewModel = EventViewModel(mode: self.mode, id: id)
        super.init(host:host, id: id)
    }
    
    override convenience init(host: UINavigationController, id: String) {
        self.init(host:host, id: id, mode: .viewOnly)
    }
    
}

extension PostCoordinator : Coordinator {
    
    func start() {
        
        startCreateEditPost()
    }
    
    func startCreateEditPost(){
        
        let vc = EditCreatePostViewController(nibName: nil, bundle: nil)
        let vm = PostViewModel(mode: .create, id: "")
        vm.coordinatorDelegate = self
        vc.viewModel = vm
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.hostNavigationController.topViewController?.present(navigationController, animated:true)
    }
    
}

extension PostCoordinator : PostViewModelCoordinatorDelegate {
    
}


//===============================================================================================
//MARK: LocationCoordinator
//MARK:==========================
class LocationCoordinator : BaseChildCoordinator{
    
    weak var parentCoordinator : LocationCoordinatorDelegate?
}

extension LocationCoordinator : Coordinator {
    
    func start() {
        let vc = LocationViewController(nibName: "LocationViewController", bundle: nil)
        let vm = LocationPickerViewModel()
        vm.coordinatorDelegate = self
        vc.viewModel = vm
        let navigationController = UINavigationController(rootViewController: vc)
        self.hostNavigationController.visibleViewController?.present(navigationController, animated:true)
    }
    
}

extension LocationCoordinator : LocationViewModelCoordinatorDelegate {
    
    func viewModelDidSelectLocation() {
        self.parentCoordinator?.locationCoordinatorDidSelectLocation()
        self.hostNavigationController.visibleViewController?.dismiss(animated: true, completion: nil)
    }
    
    func viewModelDidCancelSelection(){
        self.hostNavigationController.visibleViewController?.dismiss(animated: true, completion: nil)
    }
}

protocol LocationCoordinatorDelegate : class {
    func locationCoordinatorDidSelectLocation()
}






