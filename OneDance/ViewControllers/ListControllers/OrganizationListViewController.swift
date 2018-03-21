//
//  OrganizationListViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class OrganizationListViewController: UIViewController {

    // Photo manager
    var photoManager = PhotoManager.instance()
    
    weak var tableView : UITableView!
    // Refresh
    let refreshControl = UIRefreshControl()
    
    var viewModel : PageableOrganizationListViewModelType?{
        willSet{
            viewModel?.viewDelegate = nil
        }
        didSet{
            viewModel?.viewDelegate = self
            self.refreshDisplay()
            
        }
    }
    
    fileprivate func refreshDisplay(){
        
        self.title = self.viewModel?.title
        self.viewModel?.refresh()
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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.allowsSelection = true //this enables didSelectRowAt
        self.tableView.register(OrganizationTableCell.self, forCellReuseIdentifier: OrganizationTableCell.identifier)
        
        
        // In order to work with self sizing cells, thecontent view's item should have constraints to top and bottom
        // estimatedrowheight & UITableviewAutomaticDimension
        //https://stackoverflow.com/questions/37021236/warning-while-setting-table-row-height-for-a-tableview-cell-ios-9
        
        
        // Eger, self sizing yoksa yukaridaki kullanmak zorunda degilsin
        self.tableView.rowHeight = 64.0
        
        // refresh control
        if #available(iOS 10.0, *){
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        //refresh
        self.refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)
        
        
        // Customize navigation for back
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named:"back_white"), style: .plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc
    func goBack(sender: UIBarButtonItem){
        self.viewModel?.goBack()
    }

}

extension OrganizationListViewController : OrganizationListViewModelViewDelegate {
    
    func viewModelDidFinishUpdate(viewModel: OrganizationListViewModelType) {
        
        self.refreshControl.endRefreshing() // to stop loading animation
        self.tableView.reloadData()
    }
}

// UITableViewDataSource
extension OrganizationListViewController : UITableViewDataSource {
    
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableCell.identifier, for: indexPath) as! OrganizationTableCell
            
            if let orgItem = self.viewModel?.itemAtIndex(indexPath.row) {
                
                cell.configure(item: orgItem)
                
                
                // Image
                if let image = self.photoManager.cachedImage(for: orgItem.photo?.standard?.url?.absoluteString ?? "") {
                    cell.setOrganizationThumbnailImage(image)
                } else {
                    photoManager.retrieveImage(for: orgItem.photo?.standard?.url?.absoluteString ?? ""){ image in
                        cell.setOrganizationThumbnailImage(image)
                    }
                }
            }
            
            return cell
        }
    }
}

// UITableViewDelegate
extension OrganizationListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.isLoadingIndexPath(indexPath) else { return }
        
        print("willDisplay")
        self.fetchNextPage()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vm = self.viewModel, let item = vm.itemAtIndex(indexPath.row), let id = item.id {
            vm.requestOrganizationDetail(id: id)
        }
    }
    
}
