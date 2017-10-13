//
//  DanceTypesViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class DanceTypesViewController: UITableViewController {

    var viewModel : DanceTypesViewModel?{
        willSet{
            viewModel?.viewDelegate = nil
        }
        didSet{
            viewModel?.viewDelegate = self
            refreshDisplay()
        }
    }
    
    var isLoaded: Bool = false
    
    func refreshDisplay()
    {
        if let viewModel = self.viewModel , isLoaded {
            title = "Select your dances"
        } else {
            title = ""
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Register custom view cell
        tableView.register(UINib(nibName:"DanceTypeTableViewCell", bundle:nil), forCellReuseIdentifier: "DanceTypeCell")
        
        self.isLoaded = true
        refreshDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

extension DanceTypesViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let viewModel = self.viewModel {
            return viewModel.numberOfItems
        }
        
        return 0
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanceTypeCell", for: indexPath) as! DanceTypeTableViewCell
        cell.item = self.viewModel?.itemAtIndex(indexPath.row)
     
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.useItemAtIndex(indexPath.row)
    }
 
}

extension DanceTypesViewController : DanceTypesViewModelViewDelegate {
    
    func itemsDidChange(viewModel: DanceTypesViewModelType) {
        self.tableView.reloadData()
    }
    
    func notifyUser(_ viewModel: DanceTypesViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        return
    }
}
