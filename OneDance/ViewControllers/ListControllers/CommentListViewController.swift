//
//  CommentListViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/9/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class CommentListViewController: UIViewController {

    weak var tableView : UITableView!
    
    var sendCommentContainerView = UIView()
    var textView : UITextView = UITextView()
    var sendImageView : UIImageView = UIImageView(image: UIImage(named: "paper-plane-black"))
    
    override func loadView() {
        
        super.loadView()
        
        // Configure views and layouts
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
        
        self.view.addSubview(self.sendCommentContainerView)
        self.view.addSubview(textView)
        self.view.addSubview(self.sendImageView)

        
        self.sendCommentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.sendCommentContainerView.addSubview(self.textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.sendCommentContainerView.addSubview(self.sendImageView)
        self.sendImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        //self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.allowsSelection = false //this disables didSelectRowAt
        self.tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.identifier)
        
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Send container
        
        
        
        // Constraints
        
        self.sendCommentContainerView.addConstraints([
            NSLayoutConstraint(
                item: sendImageView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: sendImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            ),
            NSLayoutConstraint(
                item: sendImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            ),
            NSLayoutConstraint(
                item: sendImageView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
        self.sendCommentContainerView.addConstraints([
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendImageView,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.leadingMargin,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
        
        self.view.addConstraints([
            NSLayoutConstraint(
                item: sendCommentContainerView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: sendCommentContainerView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.bottomMargin,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: sendCommentContainerView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: sendCommentContainerView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 40.0
            )
        ])
        
        // Constraints
        self.view.addConstraints([
            NSLayoutConstraint(
                item: self.tableView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.tableView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.topMargin,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.tableView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.sendCommentContainerView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.tableView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0.0
            )
        ])

        
        
        // Customize navigation for back
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named:"back_white"), style: .plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc
    func goBack(sender: UIBarButtonItem){
        //self.viewModel?.goBack()
    }

}

// UITableViewDataSource
extension CommentListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        //return self.viewModel != nil && self.viewModel!.shouldShowLoadingCell ? self.viewModel!.count + 1 : self.viewModel!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if isLoadingIndexPath(indexPath) {
//            return LoadingTableCell(style: .default, reuseIdentifier: LoadingTableCell.identifier)
//        }else {
//            if let userItem = self.viewModel?.itemAtIndex(indexPath.row) {
//                
//                let cell = tableView.dequeueReusableCell(withIdentifier: UserTableCell.identifier, for: indexPath) as! UserTableCell
//                
//                cell.item = userItem
//                
//                // Image
//                if let image = self.photoManager.cachedImage(for: userItem.profilePhoto?.thumbnail?.url?.absoluteString ?? "") {
//                    cell.setUserThumbnailImage(image: image)
//                } else {
//                    photoManager.retrieveImage(for: userItem.profilePhoto?.thumbnail?.url?.absoluteString ?? ""){ image in
//                        cell.setUserThumbnailImage(image: image)
//                    }
//                }
//                
//                return cell
//                
//            } else {
//                return UITableViewCell()
//            }
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableCell.identifier, for: indexPath) as! CommentTableCell
        return cell
    }
}
