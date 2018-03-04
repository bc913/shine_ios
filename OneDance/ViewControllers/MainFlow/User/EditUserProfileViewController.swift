//
//  EditUserProfileViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/4/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class EditUserProfileViewController: UIViewController {
    
    // MARK: UI Elements
    weak var tableView : UITableView!
    
    // MARK: Internal properties
    var viewModel : UserViewModelType?{
        willSet{
            viewModel?.viewDelegate = nil
            
        } didSet{
            viewModel?.viewDelegate = self
            //self.refreshDisplay()
        }
    }
    
    fileprivate func refreshDisplay(){
        self.tableView.reloadData()
    }
    
    // Active selection
    var activeIndex : IndexPath? {
        willSet{
            if let index = self.activeIndex {
                self.cells[index.row].clearCellState()
            }
            
        }
    }
    
    var cells = [BaseFormCell]()
    
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
        
        self.tableView.allowsSelection = false
        
        // title
        self.title = "Edit Profile"
        
        
    }
    
    private func constructCells(){
        
        // Text
        if let bioCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextView, placeHolder: "Tell us about your event details") as? ShineTextViewCell{
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                bioCell.displayedValue = vm.bio ?? ""
            }
            
            bioCell.expandDelegate = self // Expanding cell delegate
            bioCell.selectionDelegate = self
            bioCell.getIndexPath = {
                return self.getIndexPathOfCell(bioCell)
            }
            
            bioCell.valueChanged = {
                self.viewModel?.bio = bioCell.textView.text
            }
            
            self.cells.append(bioCell)
            
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

        // Do any additional setup after loading the view.
        self.configureNavigationBar()
        
        self.constructCells()
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        // Create/Edit
        let createEditTitle : String = "Done"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: createEditTitle, style: .plain, target: self, action: #selector(doneEditing))
    }
    
    func doneEditing(){
        self.viewModel?.doneEditing()
    }
    
    func cancel(){
        self.viewModel?.cancelEditing()
    }
    

}

// UITableViewDataSource
extension EditUserProfileViewController : UITableViewDataSource {
    
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
extension EditUserProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if let cell = self.cells[indexPath.row] as? BaseFormCell {
            return cell.designatedHeight
        }
        return 100.0
    }
    
}

// MARK: textview dynamic expansion delegate
extension EditUserProfileViewController: ExpandingCellDelegate {
    
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?) {
        
        
        // Disabling animations gives us our desired behaviour
        //UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        //UIView.setAnimationsEnabled(true)
        
        //let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        
        //tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}

// MARK: CellSelectionDelegate
extension EditUserProfileViewController : CellSelectionDelegate{
    
    func cellSelectionChanged(_ cell: BaseFormCell, state: SelectionState, indexPath: IndexPath?) {
        if self.activeIndex != indexPath {
            self.activeIndex = indexPath
        }
        
    }
    
    func cellSelectedForLocation(){
        //self.viewModel?.requestLocation()
    }
}

fileprivate extension EditUserProfileViewController {
    
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


extension EditUserProfileViewController : UserViewModelViewDelegate {
    func viewModelDidFetchUserProfile(viewModel: UserViewModelType) {
        if viewModel.mode == .edit{
            self.refreshDisplay()
        }
        
    }
}
