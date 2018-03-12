//
//  ShineCommentListViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/9/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class ShineCommentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var inputContainerBottomConstraint: NSLayoutConstraint!
    
    let inputPlaceHolderString : String = "Add a comment"
    
    // Refresh
    let refreshControl = UIRefreshControl()
    
    // Photo manager
    var photoManager = PhotoManager.instance()
    
    var viewModel : PageableCommentListViewModelType?{
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
    }
    
    fileprivate func refreshDisplay(){
        
        self.title = self.viewModel?.title
        self.viewModel?.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerKeyboardNotifications()
        self.configureRefreshControl()
        self.configureTableView()
        self.configureInputContainer()
        self.configureNavigationBar()
        
        self.view.bringSubview(toFront: self.inputContainer)
        
        //https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShineCommentListViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        self.tableView.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func configureInputContainer(){
        
        self.sendImageView.image = UIImage(named: "paper-plane-white")
        self.sendImageView.contentMode = .scaleAspectFit
        let sendCommentTapGesture = UITapGestureRecognizer(target: self, action: #selector(addComment(tapGestureRecognizer:)))
        self.sendImageView.isUserInteractionEnabled = true
        self.sendImageView.addGestureRecognizer(sendCommentTapGesture)
        
        
        self.inputContainer.backgroundColor = UIColor(red: 44.0/255.0, green: 43.0/255.0, blue: 64.0/255.0, alpha: 1)
        
        self.inputTextView.delegate = self
        self.inputTextView.textColor = UIColor.lightGray
        self.inputTextView.text = inputPlaceHolderString
        let radius = self.sendImageView.bounds.size.height
        self.inputTextView.layer.cornerRadius = radius * 0.5
        
    }
    @objc
    func addComment(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view as? UIImageView) != nil {
            self.viewModel?.addNewComment(commentText: self.inputTextView.text!)
        }
        
    }
    
    
    
    private func configureTableView(){
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        //self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.allowsSelection = false //this disables didSelectRowAt
        self.tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.identifier)
        
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func configureNavigationBar(){
        // Customize navigation for back
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named:"back_white"), style: .plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    private func configureRefreshControl(){
        // refresh control
        if #available(iOS 10.0, *){
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        //refresh
        self.refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)

    }
    
    @objc
    func goBack(sender: UIBarButtonItem){
        self.viewModel?.goBack()
    }
    // MARK: REFRESH & FETCH
    @objc
    func refreshItems(){
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

}

extension ShineCommentListViewController : CommentListViewModelViewDelegate{
    
    func viewModelDidFinishUpdate(viewModel: CommentListViewModelType) {
        self.refreshControl.endRefreshing() // to stop loading animation
        self.tableView.reloadData()
    }
    
    func viewModelDidFinishAddingNewComment(viewModel: CommentListViewModelType) {
        self.dismissKeyboard()
        self.tableView.reloadData()
    }
}


// UITableViewDataSource
extension ShineCommentListViewController : UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableCell.identifier, for: indexPath) as! CommentTableCell
            
            if let commentItem = self.viewModel?.itemAtIndex(indexPath.row) {

                cell.item = commentItem

                // Image
                if let image = self.photoManager.cachedImage(for: commentItem.commenter?.profilePhoto?.thumbnail?.url?.absoluteString ?? "") {
                    cell.setUserThumbnailImage(image: image)
                } else {
                    photoManager.retrieveImage(for: commentItem.commenter?.profilePhoto?.thumbnail?.url?.absoluteString ?? ""){ image in
                        cell.setUserThumbnailImage(image: image)
                    }
                }
                
                cell.ownerHandler = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.viewModel?.requestUserProfile(id: commentItem.commenter?.userId ?? "")
                }

            }
            
            return cell
        }
        
    }
}

fileprivate extension ShineCommentListViewController {
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    //http://kingscocoa.com/tutorials/keyboard-content-offset/
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let keyBoardValueBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyBoardValueEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyBoardValueBegin != keyBoardValueEnd else {
                return
        }
        
        let keyboardHeight = keyBoardValueEnd.height
        
        self.tableView.contentInset.bottom = keyboardHeight
        self.inputContainerBottomConstraint.constant = -keyboardHeight
        self.view.layoutIfNeeded()
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification){
        
        self.tableView.contentInset = UIEdgeInsets.zero
        self.inputContainerBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.layoutIfNeeded()
//        })
    }
}

extension ShineCommentListViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("TextView user started typing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = inputPlaceHolderString
            textView.textColor = UIColor.lightGray
        }
        
        print("TextView user stopped typing")
    }
    
}
