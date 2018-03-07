//
//  ShineListViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/5/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit


// ============
// Interfaces
// ============

protocol PageableModel {
    var nextPageKey : String { get set }
}

protocol UserListModelType {
    var items : [UserLiteType] { get set }
    var count : Int { get }
}

protocol PageableUserListModelType: UserListModelType, PageableModel { }

// ============
// MODEL
// ============


struct UserListModel: PageableUserListModelType{
    
    var items : [UserLiteType] = [UserLite]()
    var nextPageKey: String = ""
    
    
    init?(json:[String:Any]){
        
        if let users = json["users"] as? [[String:Any]], !users.isEmpty{
            for user in users{
                if let userObj = UserLite(json: user){
                    self.items.append(userObj)
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



protocol PageableViewModel {
    func fetchNextPage()
    var shouldShowLoadingCell : Bool { get set }
    
}

protocol UserListViewModelType {
    
    weak var coordinatorDelegate : UserListVMCoordinatorDelegate? { get set }
    weak var viewDelegate : UserListViewModelViewDelegate? { get set }
    
    var model : PageableUserListModelType? { get set }
    var type : ListType { get set }
    var source : ListSource { get set }
    var id : String { get set }
    
    var count : Int { get }
    func itemAtIndex(_ index: Int) -> UserLiteType?
    
}


protocol PageableUserListViewModel : class, UserListViewModelType, PageableViewModel, Refreshable {}

protocol UserListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel: UserListViewModelType)
}

protocol UserListViewModelCoordinatorDelegate : class {
    
}

typealias UserListVMCoordinatorDelegate = UserListViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate


class UserListViewModel : PageableUserListViewModel{
    
    weak var coordinatorDelegate: UserListVMCoordinatorDelegate?
    weak var viewDelegate: UserListViewModelViewDelegate?
    
    var model : PageableUserListModelType?
    
    /// Reason for the user list
    var type : ListType
    var source : ListSource
    
    /// Id based on source
    /// source == postLike ==> postId
    var id : String = ""
    
    
    init(type: ListType, source: ListSource) {
        self.type = type
        self.source = source
    }
    
    var shouldShowLoadingCell: Bool = false
    
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
        
        if type == .like {
            // Get post likers
            return
        }
        
        if type == .going || type == .notGoing || type == .interested {
            //Get event attendance
            return
        }
        
        if type == .follower {
            // Get user follower
            return
        }
        
        if type == .following {
            // get user following
            return
        }
        
        
    }
    
    
}

class UserTableCell: UITableViewCell {
    
    var item : UserLiteType? {
        didSet{
            self.setFullAndUserNameLabels(fullname: item!.fullName, username: item!.userName)
        }
    }
    
    /// Profile image
    private let profileImageView = UIImageView(image:UIImage(named: "profile"))
    public func setUserThumbnailImage(image: UIImage){
        self.profileImageView.image = image
    }
    
    private let profileImageHeight : CGFloat = 48.0
    private let profileImageWidth : CGFloat = 48.0
    
    /// Username label
    private let fullAndUserNameLabel : UILabel = UILabel()
    
    func setFullAndUserNameLabels(fullname: String, username: String){
        
        let attributedText = NSMutableAttributedString(string: fullname.isEmpty ? "User\n" : fullname+"\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: username, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        self.fullAndUserNameLabel.attributedText = attributedText
        
    }
    
    private func setupViews(){
        self.clipsToBounds = true
        let views = [profileImageView, fullAndUserNameLabel]
        
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
       
        // Thumbnail
        self.profileImageView.contentMode = .scaleAspectFit
        
        self.fullAndUserNameLabel.numberOfLines = 2
        
        self.setupConstraints()
    }
    
    private func setupConstraints(){
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageHeight
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageWidth
            )
            ])
        
        // Username - Date
        self.self.contentView.addConstraints([
            NSLayoutConstraint(
                item: fullAndUserNameLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 8.0
            ),
            NSLayoutConstraint(
                item: fullAndUserNameLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            )
        ])
        
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FeedCell.identifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    class var identifier : String {
        return String(describing: self)
    }
    
}
//=======================
// ViewController

class ShineUserListViewController: UIViewController {
    
//    var type : ListType
//    
//    init(type: ListType) {
//        self.type = type
//        super.init(nibName: nil, bundle: nil)
//    }
    
    weak var tableView : UITableView!
    // Refresh
    let refreshControl = UIRefreshControl()
    
    var viewModel : PageableUserListViewModel?{
        willSet{
            viewModel?.viewDelegate = nil
        }
        didSet{
            viewModel?.viewDelegate = self
            
        }
    }
    
    // MARK: REFRESH & FETCH
    @objc
    func refreshItems(){
        self.viewModel?.refresh()
    }
    
    fileprivate func refreshDisplay(){
        
        self.viewModel?.refresh()
    }
    
    func fetchNextPage(){
        self.viewModel?.fetchNextPage()
    }
    
    fileprivate func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        
        guard let viewModel = self.viewModel, viewModel.shouldShowLoadingCell else {
            return false
        }
        return indexPath.row == viewModel.count
    }

    
    override func loadView() {
        
        super.loadView()
        
        // Configure views and layouts
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        self.view.addConstraints([
            NSLayoutConstraint(
                item: tableView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.topMargin,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.bottomMargin,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0.0
            )
            ])
        
        self.tableView = tableView
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        
        self.tableView.allowsSelection = false //this disables didSelectRowAt
        self.tableView.register(UserTableCell.self, forCellReuseIdentifier: UserTableCell.identifier)
        
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // refresh control
        if #available(iOS 10.0, *){
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        //refresh
        self.refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)
        
        // title
        self.title = "Users"

    
    }

}

extension ShineUserListViewController : UserListViewModelViewDelegate{
    func viewModelDidFinishUpdate(viewModel: UserListViewModelType) {
        
        self.refreshControl.endRefreshing() // to stop loading animation
        self.tableView.reloadData()
    }
}

// UITableViewDataSource
extension ShineUserListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel != nil && self.viewModel!.shouldShowLoadingCell ? self.viewModel!.count + 1 : self.viewModel!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(indexPath) {
            return LoadingTableCell(style: .default, reuseIdentifier: LoadingTableCell.identifier)
        }else {
            if let userItem = self.viewModel?.itemAtIndex(indexPath.row) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: UserTableCell.identifier, for: indexPath) as! UserTableCell
                
                cell.item = userItem
                
                return cell
                
            } else {
                return UITableViewCell()
            }
        }
    }
}

// UITableViewDelegate
extension ShineUserListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.isLoadingIndexPath(indexPath) else { return }
        
        print("willDisplay")
        self.fetchNextPage()
        
    }
    
}
