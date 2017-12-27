//
//  EditCreateEventViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/24/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class EditCreateEventViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // This is a hack to update texview dynamically when content of the text view is larger than its container cell size
    var textViewHeight : CGFloat = 150.0
    
    fileprivate var isLoaded : Bool = false
    
    // VM
    var viewModel : EventViewModelType? {
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
    }
    
    fileprivate func refreshDisplay(){
        guard self.isLoaded else { return }
        
        self.title = "Create Event"
        
        self.tableView?.reloadData()
        
    }
    
    /// The cells to display in the table.
    var cells = [BaseFormCell]()
    
    private func constructCells(){
        
        // title cell
        if let cell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .nameTitle, placeHolder: nil) as? NameTitleFormCell {
            
            // Initialize the form if it is in edit mode
            cell.displayedValue = (self.viewModel?.title)!
            
            cell.valueChanged = {
                self.viewModel?.title = cell.textField.text!
            }
            
            self.cells.append(cell)
        }
        
        // DAte cell
        if let dateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .date, placeHolder: nil) as? DateFormCell{
            
            dateCell.viewController = self
            dateCell.tableView = self.tableView
            
            if let dependentCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .datePicker, placeHolder: nil) as? DatePickerFormCell {
                
                dependentCell.parentCell = dateCell
                dateCell.dependentCells = [dependentCell]
                dateCell.getIndexPath = {
                    return self.getIndexPathOfCell(dateCell)
                }
            }
            
            dateCell.valueChanged = {
                self.updateCellsWithDependentsOfCell(dateCell)
                print("DAteCell change is not applicaple")
                
            }
            
            cells.append(dateCell)
            
        }
        
        // Location cell
        if let locationCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .location, placeHolder: nil) as? LocationFormCell{
            
            locationCell.viewController = self
            locationCell.valueChanged = {
                print("Value change is not applicaple")
                
            }
            
            cells.append(locationCell)
            
        }
        
        // More info
        if let aboutCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .info, placeHolder: nil) as? TextViewFormCell{
            
            aboutCell.tableView = self.tableView
            aboutCell.delegate = self // Expanding cell delegate
            aboutCell.getIndexPath = {
                return self.getIndexPathOfCell(aboutCell)
            }
            
            // Initialize the form if it is in edit mode
            aboutCell.displayedValue = (self.viewModel?.description)!
            
            aboutCell.valueChanged = {
                self.viewModel?.description = aboutCell.textView.text
                print("DAteCell change is not applicaple")
                
            }
            
            self.cells.append(aboutCell)
            
        }
        
    }
    
    /// Insert or remove cells into the cells list per the current value of a SwitchCell object.
    func updateCellsWithDependentsOfCell(_ cell: DateFormCell, sectionIndex : Int = 0) {
        // Multiple sections. You have to hard code the corresponding cells array
        
        //Single section
        
        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
        {
            let index = (indexPath as NSIndexPath).row + 1
            if cell.tapState {
                cells.insert(contentsOf: cell.dependentCells as [BaseFormCell], at: index)
            }
            else {
                let removeRange = index..<(index + cell.dependentCells.count)
                cells.removeSubrange(removeRange)
            }
        }
        
        
        
    }
    
    /// Return the index of a given cell in the cells list.
    func getIndexPathOfCell(_ cell: UITableViewCell) -> IndexPath? {
        
        //Single section
        if let row = cells.index(where: { $0 == cell }) {
            return IndexPath(row: row, section: 0)
        }
        return nil
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.configureNavigationBar()
        self.registerKeyboardNotifications()
        
        
        self.isLoaded = true
        
        // Do any additional setup after loading the view.
        self.refreshDisplay()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTableView(){
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        // Create the cells
        self.constructCells()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        //self.tableView?.estimatedRowHeight = 100 // Delegate method overwrites this
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCreateEditEvent))
        
        // Create/Edit
        var createEditTitle : String = "Create"
        if self.viewModel?.mode == .edit {
            createEditTitle = "Edit"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: createEditTitle, style: .plain, target: self, action: #selector(createEditEvent))
    }
    
    func createEditEvent(){
        self.viewModel?.create()
    }
    
    func cancelCreateEditEvent() {
        print("create Event")
        self.viewModel?.cancel()
    }

}

// UITableViewDataSource
extension EditCreateEventViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        var sectIndex = section
//        
//        if let index = self.formSections.index(where: {$0.sectionIndex == section}) {
//            sectIndex = index
//        }
//        
//        return self.formSections[sectIndex].title
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cells[indexPath.row]
    }
}

// UITableViewDelegate
extension EditCreateEventViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.cells[indexPath.row] is TextViewFormCell {
            return self.textViewHeight
        }
        
        if let cell = self.cells[indexPath.row] as? BaseFormCell {
            return cell.designatedHeight
        }
        return 100.0
    }
    
}

fileprivate extension EditCreateEventViewController {
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let keyBoardValueBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyBoardValueEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyBoardValueBegin != keyBoardValueEnd else {
                return
        }
        
        let keyboardHeight = keyBoardValueEnd.height
        
        self.tableView.contentInset.bottom = keyboardHeight
    }
}

// MARK: textview dynamic expansion delegate
extension EditCreateEventViewController: ExpandingCellDelegate {
    
    func updateCellHeight(height: CGFloat, indexPath: IndexPath) {
        //expandingCellHeight = height
        
        self.textViewHeight = height + 20
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        //let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        
        //tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}

// MARK: EventViewModelViewDelegate
extension EditCreateEventViewController : EventViewModelViewDelegate {
    
    func editCreateDidSucceed(viewModel: EventViewModelType){
        self.dismiss(animated: true, completion: nil)
    }
    
    func editCreateDidCancelled(viewModel: EventViewModelType){
        self.dismiss(animated: true, completion: nil)
    }
}
