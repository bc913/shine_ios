//
//  TimeLineViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

final class TimeLineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Photo manager
    var photoManager = PhotoManager.instance()
    
    // Refresh
    let refreshControl = UIRefreshControl()
    
    /// Test cells
    var cells = [BaseFeedCell]()
    
    var viewModel : TimeLineViewModelType? {
        
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shine"
        self.configureTableView()
        self.configureNavigationBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureNavigationBar(){
        
        // Add skip
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    private func configureTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        self.tableView.register(FeedWithMediaCell.self, forCellReuseIdentifier: FeedWithMediaCell.identifier)
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        // Disable selection
        self.tableView.allowsSelection = false //this disables didSelectRowAt
        
        // Row height
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // refresh control
        if #available(iOS 10.0, *){
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        //refresh
        self.refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)

        
    }
    
    // MARK: REFRESH & FETCH
    @objc
    func refreshItems(){
        self.viewModel?.refreshItems()
    }
    
    fileprivate func refreshDisplay(){
        
        self.viewModel?.refreshItems()
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

    
    func addTapped(){
        self.showActionSheet()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Create Organization", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.createOrganizationAction()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Create Event", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.createEventAction()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Create Post", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.createPostAction()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func createOrganizationAction(){
        /*
        let vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
        vc.viewModel = OrganizationViewModel(mode: .create)
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
 */
        
        self.viewModel?.createOrganization()
    }
    
    private func createEventAction(){
        
        self.viewModel?.createEvent()
    }
    
    private func createPostAction(){
        self.viewModel?.createPost()
    }

}

extension TimeLineViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.isLoadingIndexPath(indexPath) else { return }
        
        print("willDisplay")
        self.fetchNextPage()
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 276.0
//    }
    
}

extension TimeLineViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel != nil && self.viewModel!.shouldShowLoadingCell ? self.viewModel!.count + 1 : self.viewModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingIndexPath(indexPath) {
            return LoadingTableCell(style: .default, reuseIdentifier: LoadingTableCell.identifier)
        } else {
            
            if let feedItem = self.viewModel?.itemAtIndex(indexPath.row) {
                
                if feedItem.hasPostMedia {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedWithMediaCell.identifier, for: indexPath) as! FeedWithMediaCell
                    
                    // Feed
                    cell.item = feedItem
                    
                    // User photo
                    self.assignUserThumbnailImage(cell: cell as FeedableCell, url: feedItem.profilePhotoUrl)
                    
                    // Post media
                    self.assignPostMedia(cell: cell, url: feedItem.postMediaUrl)
                    
                    return cell
                } else {
                    
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
                    
                    // Feed
                    cell.item = feedItem
                    
                    // User photo
                    self.assignUserThumbnailImage(cell: cell as FeedableCell, url: feedItem.profilePhotoUrl)
                    
                    
                    return cell
                }
            }
            
            
            return UITableViewCell()
        }
        
        
    }
    
    func assignUserThumbnailImage(cell: FeedableCell, url: String){
        
        if let image = self.photoManager.cachedImage(for: url) {
            cell.setUserThumbnailImage(image: image)
        } else {
            photoManager.retrieveImage(for: url){ image in
                cell.setUserThumbnailImage(image: image)
            }
        }
    }
    
    func assignPostMedia(cell: FeedWithMediaCell, url: String){
        
        if let image = self.photoManager.cachedImage(for: url) {
            cell.setPostImageView(image: image)
        } else {
            photoManager.retrieveImage(for: url){ image in
                cell.setPostImageView(image: image)
            }
        }
    }
    
}

extension TimeLineViewController : TimeLineViewModelViewDelegate {
    func viewModelDidFinishUpdate(viewModel: TimeLineViewModelType){
        self.refreshControl.endRefreshing() // to stop loading animation
        self.tableView.reloadData()
        
    }
}
