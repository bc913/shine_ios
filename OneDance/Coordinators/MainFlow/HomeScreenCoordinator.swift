//
//  HomeScreenContainerCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

enum ListType {
    
    case user
    case organization
    case post
    case event
    case comment
    case attendanceInterestGoing
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
//=======================

// Every parent coordinator shoul adopt this
protocol ChildCoordinatorDelegate : class {
    
    // LIST
    // User request organization follower list
    // User request user follower list
    // User reques user following list
    // User request a post's liker list
    // User request event attendance/interested/not going list
    
    func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, listType: ListType )
    
    // User request an organization's post list
    // User request another user's post list
    
    // User request a post's comment list
    
    // User request other djs/instructors event list
    // A dance type is selected and show related events and organization around the user
    //func childCoordinatorDidRequestADanceTypeEventList(sender:BaseChildCoordinator, type: IDanceType, id: String)
    
    
    // EVENT
    // User request an event's detail
    func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // ORGANIZATION
    // User request an organization's detail
    func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // USER
    func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode)
    
    
    // POST
    // regular, uploadPhotoOnly, likes or follows
    // USer request a post's detail
    func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String)
    
    
    // MEDIA
    
    // Notify timeline
    //func childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
    
}

/// Base class definitions for all child coordinators under container coordinator.
/// Every child coordinator should inherit this.
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
    
    func viewModelDidSelectUserProfile(viewModel: Modeable, userID: String, requestedMode: ShineMode )
    func viewModelDidSelectOrganizationProfile(viewModel: Modeable, organizationID: String, requestedMode: ShineMode)
    func viewModelDidSelectEvent(viewModel: Modeable, eventID: String, requestedMode: ShineMode)
    func viewModelDidSelectList(viewModel: Modeable, id: String, listType: ListType)
    func viewModelDidSelectPost(viewModel: Modeable, postID: String)
}

/// coordinator delegate of every child view model has this
extension BaseChildCoordinator : ChildViewModelCoordinatorDelegate {
    
    // User
    func viewModelDidSelectUserProfile(viewModel: Modeable, userID: String, requestedMode: ShineMode ) {
        self.delegate?.childCoordinatorDidRequestUserDetail(sender: self, id: userID, mode: requestedMode)
    }
    // Organization
    func viewModelDidSelectOrganizationProfile(viewModel: Modeable, organizationID: String, requestedMode: ShineMode){
        self.delegate?.childCoordinatorDidRequestOrganizationDetail(sender: self, id: organizationID, mode: requestedMode)
    }
    //Event
    func viewModelDidSelectEvent(viewModel: Modeable, eventID: String, requestedMode: ShineMode) {
        self.delegate?.childCoordinatorDidRequestEventDetail(sender: self, id: eventID, mode: requestedMode)
    }
    // List
    func viewModelDidSelectList(viewModel: Modeable, id: String, listType: ListType){
        self.delegate?.childCoordinatorDidRequestList(sender: self, id: id, listType: listType)
    }
    // Post
    func viewModelDidSelectPost(viewModel: Modeable, postID: String){
        self.delegate?.childCoordinatorDidRequestPostDetail(sender: self, id: postID)
    }
}
//===============================================================================================
//MARK: ContainerCoordinator
//===============================================================================================

class HomeScreenContainerCoordinator : Coordinator{
    
    var childCoordinators = [String: BaseChildCoordinator]()
    var containerNavigationController: UINavigationController
    
    init(containerNavController: UINavigationController) {
        self.containerNavigationController = containerNavController
    }
    
    func start() {
        self.showTimeLine()
    }
    
    var activeCoordinator : BaseChildCoordinator?
    
//    var userCoordinator : UserProfileCoordinator?
//    var organizationCoordinator : OrganizationProfileCoordinator?
//    var eventCoordinator : EventCoordinator?
//    var timeLineCoordinator : TimeLineCoordinator?
//    var listCoordinator : ListCoordinator?
//    var postCoordinator : PostCoordinator?
//    
//    func updateChildCoordinators(sender: BaseChildCoordinator){
//        if sender is UserProfileCoordinator {
//            childCoordinators["USER"] = nil
//        } else if sender is OrganizationProfileCoordinator {
//            childCoordinators["ORGANIZATION"] = nil
//        } else if sender is EventCoordinator {
//            childCoordinators["EVENT"] = nil
//        } else if sender is TimeLineCoordinator {
//            childCoordinators["TIMELINE"] = nil
//        } else if sender is ListCoordinator {
//            childCoordinators["LIST"] = nil
//        } else if sender is PostCoordinator {
//            childCoordinators["POST"] = nil
//        }
//        
//    }
}

extension HomeScreenContainerCoordinator : ChildCoordinatorDelegate {
    
    func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
        
//        self.updateChildCoordinators(sender: sender)
//        let userCoordinator = UserProfileCoordinator(host: self.containerNavigationController, id: id,mode: mode)
//        childCoordinators["USER"] = userCoordinator
//        userCoordinator.delegate = self
//        userCoordinator.start()
    }
    
    func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
//        self.updateChildCoordinators(sender: sender)
//        let orgCoordinator = OrganizationProfileCoordinator(host: self.containerNavigationController, id: id, mode: mode)
//        childCoordinators["ORGANIZATION"] = orgCoordinator
//        orgCoordinator.delegate = self
//        orgCoordinator.start()
        
    }
    
    func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String, mode: ShineMode){
//        self.updateChildCoordinators(sender: sender)
//        let eventCoordinator = EventCoordinator(host: self.containerNavigationController, id: id, mode: mode)
//        childCoordinators["EVENT"] = eventCoordinator
//        eventCoordinator.delegate = self
//        eventCoordinator.start()
    }
    
    func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, listType: ListType ){
//        self.updateChildCoordinators(sender: sender)
//        let listCoordinator = ListCoordinator(host: self.containerNavigationController, id: id, listType: listType)
//        childCoordinators["LIST"] = listCoordinator
//        listCoordinator.delegate = self
//        listCoordinator.start()
    }
    
    func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String){
//        self.updateChildCoordinators(sender: sender)
//        let postCoordinator = PostCoordinator(host: self.containerNavigationController, id: id)
//        childCoordinators["POST"] = postCoordinator
//        postCoordinator.delegate = self
//        postCoordinator.start()
    }
    
    func childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType ){
        // This is to refresh timeline after create an event or organization
        self.showTimeLine()
    }
    
    
}
    
extension HomeScreenContainerCoordinator : TimeLineCoordinatorDelegate {
    
    func showTimeLine() {
        
        let timelineCoordinator = TimeLineCoordinator(host: self.containerNavigationController, id: PersistanceManager.User.userId!)
        childCoordinators["TIMELINE"] = timelineCoordinator
        activeCoordinator = timelineCoordinator
        timelineCoordinator.delegate = self
        timelineCoordinator.start()
        
    }
}

//===============================================================================================
//MARK: TimelineCoordinator
//===============================================================================================
protocol TimeLineCoordinatorDelegate : class {
    func showTimeLine()
}

class TimeLineCoordinator : BaseChildCoordinator {
    var mode : ShineMode
    //private var viewModel : EventViewModel? // Emin degilim
    
    init(host: UINavigationController, id: String, mode: ShineMode = .viewOnly) {
        self.mode = mode
        //self.viewModel = EventViewModel(mode: self.mode, id: id)
        super.init(host:host, id: id)
    }
    
    override convenience init(host: UINavigationController, id: String) {
        self.init(host:host, id: id, mode: .viewOnly)
    }
}

extension TimeLineCoordinator : Coordinator {
    func start() {
        let vc = TimeLineViewController(nibName: "TimeLineViewController", bundle: nil)
        print("TimeLineCoordinator.start()")
        let viewModel = TimeLineViewModel() // it doesn't have mode. It is always view only mode.
        viewModel.coordinatorDelegate = self //typealias TimelineCoordinatorDelegate: ChildViewModelCoordinatorDelegate & TimeLineViewModelCoordinatorDelegate
        vc.viewModel = viewModel
        self.hostNavigationController.setViewControllers([vc], animated: false) // It is always root controller
    }
}

extension TimeLineCoordinator : TimeLineViewModelCoordinatorDelegate {
    
    func viewModelDidSelectCreateOrganization(viewModel: TimeLineViewModelType) {
        print("Create Organization")
        let coordinator = OrganizationCoordinator(host: self.hostNavigationController, id: "", mode: .create)
        coordinator.start()
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
    //private var viewModel : EventViewModel? // Emin degilim
    
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
        
        var vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
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
