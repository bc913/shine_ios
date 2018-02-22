//
//  TimeLineViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
    
    fileprivate func refreshDisplay(){
        
        self.viewModel?.refreshItems()
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
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        // Disable selection
        self.tableView.allowsSelection = false //this disables didSelectRowAt
        
        
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

}

extension TimeLineViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 276.0
    }
    
}

extension TimeLineViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        
        if let feedItem = self.viewModel?.itemAtIndex(indexPath.row) {
            cell.item = feedItem
        }
        
        return cell
    }
    
}

extension TimeLineViewController : TimeLineViewModelViewDelegate {
    func viewModelDidFinishUpdate(viewModel: TimeLineViewModelType){
        self.tableView.reloadData()
        
    }
}
