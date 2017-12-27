// =====================================================================
//  ===================== UTILITIES ================================
// =====================================================================
enum ActiveMode {
	case create
	case edit
	case view
	case delete
}

enum PresentationMode {
	case modal
	case navigation
}

enum ShineType {
	case event
	case organization
}

enum ListType {

	case user
	case organization
	case post
	case event
	case comment
	case attendanceInterestGoing
}

enum DetailPurpose {
	case viewOnly
	case commentOnly
	case wholeEdit
}

enum PostType {
	case event
	case regular
	case uploadPhoto
	case otherUserRelationship // when a following likes or follows 
}


enum NotificationType{

	case updateEvent
	case createEvent
}

protocol Modeable {
	var mode : ActiveMode { get set }	
}

protocol Coordinator {
	func start()
}

protocol ChildCoordinatorDelegate : class {

	// LIST
	// User request organization follower list
	// User request user follower list
	// User reques user following list
	// User request a post's liker list
	// User request event attendance/interested/not going list

	func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, listType: ListType ){}

	// User request an organization's post list
	// User request another user's post list

	// User request a post's comment list 

	// User request other djs/instructors event list	
	// A dance type is selected and show related events and organization around the user
	func childCoordinatorDidRequestADanceTypeEventList(sender:BaseChildCoordinator, type: IDanceType, id: String){}


	// EVENT
	// User request an event's detail
	func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String){}


	// ORGANIZATION
	// User request an organization's detail
	func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String){}


	// USER
	func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator id: String){}


	// POST
	// regular, uploadPhotoOnly, likes or follows
	// USer request a post's detail
	func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String){}


	// MEDIA

	// Notify timeline
	func childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )

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

	func viewModelDidSelectUserProfile(viewModel: Modeable, userID: String ){}
	func viewModelDidSelectOrganizationProfile(viewModel: Modeable, organizationID: String){}
	func viewModelDidSelectEvent(viewModel: Modeable, eventID: String){}
	func viewModelDidSelectList(viewModel: Modeable, id: String, listType: ListType){}
	func viewModelDidSelectPost(viewModel: Modeable, postID: String){}
}


extension BaseChildCoordinator : ChildViewModelCoordinatorDelegate {

	func viewModelDidSelectUserProfile(viewModel: Modeable, userID: String, requestedMode: ActiveMode ) {
 		self.delegate?.childCoordinatorDidRequestUserDetail(sender: self, id: userID, mode: requestedMode)
 	}

 	func viewModelDidSelectOrganizationProfile(viewModel: Modeable, organizationID: String, requestedMode: ActiveMode){
 		self.delegate?.childCoordinatorDidRequestOrganizationDetail(sender: self, id: organizationID, mode: requestedMode)
 	}

 	func viewModelDidSelectEvent(viewModel: Modeable, eventID: String, requestedMode: ActiveMode) {
 		self.delegate?.childCoordinatorDidRequestEventDetail(sender: self, id: eventID, mode: requestedMode)
 	}

 	func viewModelDidSelectList(viewModel: Modeable, id: String, listType: ListType){
 		self.delegate?.childCoordinatorDidRequestList(sender: self, id: id, listType: listType)
 	}
	func viewModelDidSelectPost(viewModel: Modeable, postID: String){
		self.delegate?childCoordinatorDidRequestPostDetail(sender: self, id: postID)
	}
}

// =====================================================================
// =====================================================================
// =====================================================================

class ContainerCoordinator : Coordinator{

	var childCoordinators = [String: BaseChildCoordinator]()
	var containerNavigationController: UINavigationController

	init(containerNavController: UINavigationController) {
		self.containerNavigationController = containerNavController
	}

	func start() {
		self.showTimeLine()
	}

	var activeCoordinator : BaseChildCoordinator?

	var userCoordinator : UserProfileCoordinator?
	var organizationCoordinator : OrganizationProfileCoordinator?
	var eventCoordinator : EventCoordinator?
	var timeLineCoordinator : TimeLineCoordinator?
	var listCoordinator : ListCoordinator?
	var postCoordinator : PostCoordinator?

	func updateChildCoordinators(sender: BaseChildCoordinator){
		if sender is UserProfileCoordinator {
			childCoordinators["USER"] = nil
		} else if sender is OrganizationProfileCoordinator {
			childCoordinators["ORGANIZATION"] = nil
		} else if sender is EventCoordinator {
			childCoordinators["EVENT"] = nil
		} else if sender is TimeLineCoordinator {
			childCoordinators["TIMELINE"] = nil
		} else if sender is ListCoordinator {
			childCoordinators["LIST"] = nil
		} else if sender is PostCoordinator {
			childCoordinators["POST"] = nil
		}

}

extension ContainerCoordinator : ChildCoordinatorDelegate {

	func childCoordinatorDidRequestUserDetail(sender: BaseChildCoordinator, id: String, mode: ActiveMode){

		self.updateChildCoordinators(sender: sender)
		let userCoordinator = UserProfileCoordinator(host: self.containerNavigationController, id: id,mode: mode)
		childCoordinators["USER"] = userCoordinator
		userCoordinator.delegate = self
		userCoordinator.start()
	}

	func childCoordinatorDidRequestOrganizationDetail(sender: BaseChildCoordinator, id: String, mode: ActiveMode){
		self.updateChildCoordinators(sender: sender)
		let orgCoordinator = OrganizationProfileCoordinator(host: self.containerNavigationController, id: id, mode: mode)
		childCoordinators["ORGANIZATION"] = orgCoordinator
		orgCoordinator.delegate = self
		orgCoordinator.start()

	}

	func childCoordinatorDidRequestEventDetail(sender: BaseChildCoordinator, id: String, mode: ActiveMode){
		self.updateChildCoordinators(sender: sender)
		let eventCoordinator = EventCoordinator(host: self.containerNavigationController, id: id, mode: mode)
		childCoordinators["EVENT"] = eventCoordinator
		eventCoordinator.delegate = self
		eventCoordinator.start()
	}

	func childCoordinatorDidRequestList(sender: BaseChildCoordinator, id: String, listType: ListType ){
		self.updateChildCoordinators(sender: sender)
		let listCoordinator = ListCoordinator(host: self.containerNavigationController, id: id, listType: listType)
		childCoordinators["LIST"] = listCoordinator
		listCoordinator.delegate = self
		listCoordinator.start()
	}

	func childCoordinatorDidRequestPostDetail(sender: BaseChildCoordinator, id: String){
		self.updateChildCoordinators(sender: sender)
		let postCoordinator = PostCoordinator(host: self.containerNavigationController, id: id)
		childCoordinators["POST"] = postCoordinator
		postCoordinator.delegate = self
		postCoordinator.start()
	}

	func childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType ){
		// This is to refresh timeline after create an event or organization
		self.showTimeLine()
	}


}

extension ContainerCoordinator : TimeLineCoordinatorDelegate {
	
	func showTimeLine {

		let timelineCoordinator = TimeLineCoordinator(host: self.containerNavigationController, id: PersistanceManager.userID)
		childCoordinators["TIMELINE"] = timelineCoordinator
		timelineCoordinator.delegate = self
		timelineCoordinator.start()
		
	}
}


// =====================================================================
// =====================================================================
// =====================================================================


// =====================================================================

class TimeLineCoordinator : BaseChildCoordinator {
	
}

extension TimeLineCoordinator : Coordinator {
	func start() {
		let vc = TimeLineViewController(nib:"TimeLineViewController", bundle:nil)
		var viewModel = TimeLineViewModel() // it doesn't have mode. It is always view only mode.
		viewModel.coordinatorDelegate = self //typealias TimelineCoordinatorDelegate: ChildViewModelCoordinatorDelegate & TimeLineViewModelCoordinatorDelegate
		vc.viewModel = vc
		self.hostNavigationController.setViewControllers([vc], animated: false) // It is always root controller
	}
}

protocol TimeLineViewModelCoordinatorDelegate : class {

	func viewModelDidSelectCreateEvent(viewModel: TimeLineViewModel){}
	func viewModelDidSelectCreateOrganization(viewModel: TimeLineViewModel){}


	// Handle the refresh inside viewModel and update viewDelegate
}

extension TimeLineCoordinator : TimeLineViewModelCoordinatorDelegate{
	
}

// =====================================================================
class UserProfileCoordinator : BaseChildCoordinator {
	var mode : ActiveMode

	init(host: UINavigationController, id: String, mode: ActiveMode = .view) {
		self.mode = mode
		super.init(host:host, id: id)
	}

	override convenience init(host: UINavigationController, id: String) {
		self.init(host:host, id: id, mode: .view)
	}
}

extension UserProfileCoordinator : Coordinator {
	
	func start() {

		if self.mode == .view 
		{
			self.startViewUserProfile()				
		} 
		else 
		{
			self.startUserEditCreate()
		}
	}

	func startViewUserProfile(){

		var vc = UserProfileViewController(nibName:"UserProfileViewController", bundle: nil)
		var viewModel = UserProfileViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias UserProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & UserProfileViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.push(viewController: vc, animated: true)
	}

	func startUserEditCreate(){

		var vc = EditCreateUserProfileViewController(nibName: "EditCreateUserProfileViewController", bundle: nil)
		var viewModel = UserProfileViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias UserProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & UserProfileViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.topViewController.present(vc, animated:true)
	}
}

protocol UserProfileViewModelCoordinatorDelegate {
	// Edit - Create
	func viewModelDidRequestEditing(viewModel: UserProfileViewModel)
	func viewModelDidFinishEditing(viewModel: UserProfileViewModel)
	func viewModelDidCancelEditing(viewModel: UserProfileViewModel)
}

extension UserProfileCoordinator : UserProfileViewModelCoordinatorDelegate {

 	func viewModelDidRequestEditing(viewModel: UserProfileViewModel) {

		self.mode = .edit
		self.startUserEditCreate()
	}

	func viewModelDidFinishEditing(viewModel: UserProfileViewModel) {

		self.mode = .view				
		// End editing
		if var viewUserProfileVC = self.hostNavigationController.topViewController as? UserProfileViewController, 
			var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateUserProfileViewController 
			// var editCreateVC = viewUserProfileVC.presentedViewController as? EditCreateUserProfileViewController
		{	
			viewUserProfileVC.dismiss(animated: true)
			viewUserProfileVC.viewModel.refresh() // no need to navigate to the timeline
			return
		}

		// End creating
		if  var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateUserProfileViewController, 
			editCreateVC.viewModel.mode == .create {
				self.hostNavigationController.topViewController.dismiss(animated: true)
				// Notify & navigate timeline
				//delegate?.childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
				return
		}
	}

	func viewModelDidCancelEditing(viewModel: UserProfileViewModel) {
		self.mode = .view
		self.hostNavigationController.topViewController.dismiss(animated: true)
	}
 } 

// =====================================================================
class OrganizationProfileCoordinator : BaseChildCoordinator{

	var mode : ActiveMode
	//private var viewModel : EventViewModel? // Emin degilim

	init(host: UINavigationController, id: String, mode: ActiveMode = .view) {
		self.mode = mode
		//self.viewModel = EventViewModel(mode: self.mode, id: id)
		super.init(host:host, id: id)
	}

	override convenience init(host: UINavigationController, id: String) {
		self.init(host:host, id: id, mode: .view)
	}
}

extension OrganizationProfileCoordinator : Coordinator {

	func start() {

		if self.mode == .view 
		{
			self.startViewOrganizationDetail()				
		} 
		else 
		{
			self.startCreateEditOrganization()
		}
	}

	func startViewOrganizationDetail(){

		var vc = OrganizationDetailViewController(nibName:"OrganizationDetailViewController", bundle: nil)
		var viewModel = OrganizationViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias OrganizationProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & OrganizationViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.push(viewController: vc, animated: true)
	}

	func startCreateEditOrganization(){

		var vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
		var viewModel = OrganizationViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias OrganizationProfileCoordinatorDelegate = ChildViewModelCoordinatorDelegate & OrganizationViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.topViewController.present(vc, animated:true)
	}
}


protocol OrganizationViewModelCoordinatorDelegate : class {
	// Edit
	func viewModelDidRequestEditing(viewModel: OrganizationViewModel)
	func viewModelDidFinishEditing(viewModel: OrganizationViewModel)
	func viewModelDidCancelEditing(viewModel: OrganizationViewModel)
}

extension OrganizationProfileCoordinator : OrganizationViewModelCoordinatorDelegate {

	func viewModelDidRequestEditing(viewModel: OrganizationViewModel) {

		self.mode = .edit
		self.startCreateEditOrganization()
	}

	func viewModelDidFinishEditing(viewModel: OrganizationViewModel) {

		self.mode = .view				
		// End editing
		if var viewOrgVC = self.hostNavigationController.topViewController as? OrganizationDetailViewController, 
			var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateOrganizationViewController 
			// var editCreateVC = viewOrgVC.presentedViewController as? EditCreateOrganizationViewController
		{	
			viewOrgVC.dismiss(animated: true)
			viewOrgVC.viewModel.refresh() // no need to navigate to the timeline
			return
		}

		// End creating
		if  var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateOrganizationViewController, 
			editCreateVC.viewModel.mode == .create {
				self.hostNavigationController.topViewController.dismiss(animated: true)
				// Notify & navigate timeline
				//delegate?.childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
				return
		}
	}

	func viewModelDidCancelEditing(viewModel: OrganizationViewModel) {
		self.mode = .view
		self.hostNavigationController.topViewController.dismiss(animated: true)
	}
}


// =====================================================================

class PostCoordinator : BaseChildCoordinator {

	private var detailPurpose : DetailPurpose

	init(host: UINavigationController, id: String, purpose: DetailPurpose) {
		self.detailPurpose = purpose
		super.init(host: host, id: id)
	}

	override convenience init(host: UINavigationController, id: String) {
		self.init(host: host, id: id, puspose: .viewOnly)
	}
}

extension PostCoordinator : Coordinator {
	func start(){

		let vc = PostDetailViewController(nibName:"PostDetailViewController", bundle: nil)
		var viewModel = PostDetailViewModel(id: self.id)
		viewModel.coordinatorDelegate = self
		vc.viewModel = viewModel
		self.hostNavigationController.push(vc, animated: true)
	}
}

// =====================================================================

class EventCoordinator : BaseChildCoordinator {

	var mode : ActiveMode
	//private var viewModel : EventViewModel? // Emin degilim

	init(host: UINavigationController, id: String, mode: ActiveMode = .view) {
		self.mode = mode
		//self.viewModel = EventViewModel(mode: self.mode, id: id)
		super.init(host:host, id: id)
	}

	override convenience init(host: UINavigationController, id: String) {
		self.init(host:host, id: id, mode: .view)
	}
	
}

extension EventCoordinator :  Coordinator{

	func start() {

		if self.mode == .view 
		{
			self.startEventDetail()				
		} 
		else 
		{
			self.startEventCreatingEditing()
		}
	}

	func startViewEventDetail(){

		var vc = EventDetailViewController(nibName:"EventDetailViewController", bundle: nil)
		var viewModel = EventViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias EventDetailCoordinatorDelegate = ChildViewModelCoordinatorDelegate & EventViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.push(viewController: vc, animated: true)
	}

	func startEventCreatingEditing(){

		var vc = EditCreateEventViewController(nibName: "EditCreateEventViewController", bundle: nil)
		var viewModel = EventViewModel(mode: self.mode, id: self.mode == .create ? "" : self.id)
		viewModel.coordinatorDelegate = self //typealias EventDetailCoordinatorDelegate = ChildViewModelCoordinatorDelegate & EventViewModelCoordinatorDelegate
		
		vc.viewModel = viewModel
		self.hostNavigationController.topViewController.present(vc, animated:true)
	}
}

protocol EventViewModelCoordinatorDelegate : class {
	// edit here
	func viewModelDidRequestEditing(viewModel: EventViewModel)
	func viewModelDidFinishEditing(viewModel: EventViewModel)
	func viewModelDidCancelEditing(viewModel: EventViewModel)
}

extension EventCoordinator : EventViewModelCoordinatorDelegate {

	func viewModelDidRequestEditing(viewModel: EventViewModel) {
		self.mode = .edit
		self.startEventCreatingEditing()
	}

	func viewModelDidFinishEditing(viewModel: EventViewModel){

		self.mode = .view

		// End editing
		if var viewEventVC = self.hostNavigationController.topViewController as? EventDetailViewController, 
			var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateEventViewController 
			// var editCreateVC = viewEventVC.presentedViewController as? EditCreateEventViewController
		{	
			viewEventVC.dismiss(animated: true)
			viewEventVC.viewModel.refresh() // no need to navigate to the timeline
			return
		}

		// End creating
		if  var editCreateVC = self.hostNavigationController.visibleViewController as? EditCreateEventViewController, 
			editCreateVC.viewModel.mode == .create {
				self.hostNavigationController.topViewController.dismiss(animated: true)
				// Notify & navigate timeline
				//delegate?.childCoordinatorNotifyTimeline(sender:BaseChildCoordinator, id: String, notification: NotificationType )
				return
		}

		
	}

	func viewModelDidCancelEditing(viewModel: EventViewModel){
		self.mode = .view
		self.hostNavigationController.topViewController.dismiss(animated: true)
	}


}
