//
//  DanceTypesViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/15/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class DanceTypesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if self.viewModel?.selectedItems != nil || (self.viewModel?.selectedItems?.count)! > 0 {
            self.viewModel?.selectedItems?.removeAll()
        }
        
        self.tableView.indexPathsForSelectedRows?.forEach({indexPath in
            self.viewModel?.selectedItems?.append((self.viewModel?.itemAtIndex(indexPath.row))!)
        })
        
        self.viewModel?.submit()
        
    }
    
    
    var viewModel : DanceTypesViewModel?{
        willSet{
            viewModel?.viewDelegate = nil
        }
        didSet{
            viewModel?.viewDelegate = self
            print("DanceTypesVC.viewmodel.didSet()")
            refreshDisplay()
        }
    }
    
    var isLoaded: Bool = false
    var isAnyRowSelected = false
    
    func refreshDisplay()
    {
        if let viewModel = self.viewModel , isLoaded {
            
            self.title = "Select your dances"
        } else {
            self.title = ""
        }
        self.tableView?.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        
        // Configure button
        self.doneButton.configure(title: "Done", backgroundColor: UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0))
        self.doneButton.isHidden = true
        
        // Configure navigation bar
        // TODO: Update this code
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName : UIColor.white]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        // Register custom view cell
        tableView.register(UINib(nibName:"DanceTypeTableViewCell", bundle:nil), forCellReuseIdentifier: "DanceTypeCell")
        
        // Multiple selection
        self.tableView.allowsMultipleSelection = true
        
        self.isLoaded = true
        refreshDisplay()
        
        
        
        print("DanceTypesVC :: viewDidLoad()")
    }
    
    fileprivate func checkForSelection(){
        if self.tableView.indexPathsForSelectedRows != nil {
            self.doneButton.isHidden = false
        } else {
            self.doneButton.isHidden = true
        }
        
    }
    
    private func configureNavigationBar(){
        // Kendisinden sonra stack a push edilen view controllerin navigation bar back buttonu nu kontrol eder
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }

    
    
}

extension DanceTypesViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let viewModel = self.viewModel {
            return viewModel.numberOfItems
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanceTypeCell", for: indexPath) as! DanceTypeTableViewCell
        cell.item = self.viewModel?.itemAtIndex(indexPath.row)
        //cell.selectionStyle = .none
        
        return cell
    }
}

extension DanceTypesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = self.tableView.cellForRow(at: indexPath) as? DanceTypeTableViewCell{
            selectedCell.layer.borderColor = UIColor.blue.cgColor
            selectedCell.accessoryType = .checkmark
            print("osman selected")
            self.checkForSelection()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedCell = self.tableView.cellForRow(at: indexPath) as? DanceTypeTableViewCell {
            selectedCell.layer.borderColor = selectedCell.defaultBorderColor
            selectedCell.accessoryType = .none
            self.checkForSelection()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
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
