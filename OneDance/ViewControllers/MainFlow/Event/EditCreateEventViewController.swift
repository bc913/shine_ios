//
//  EditCreateEventViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/24/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit


class EditCreateEventViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // This is a hack to update texview dynamically when content of the text view is larger than its container cell size
    var textViewHeight : CGFloat = 150.0
    
    // Cell height for nameWithImage cell
    var nameWithImageCellHeight : CGFloat = 66.0
    
    // Cell height for date picker
    var datePickerCellHeight : CGFloat = 44.0
    
    // Image picker controller for nameWithImagecell
    var imagePickerController = UIImagePickerController()
    
    fileprivate var isLoaded : Bool = false
    
    // ACtive selection
    var activeIndex : IndexPath? {
        willSet{
            if let index = self.activeIndex {
                self.cells[index.row].clearCellState()
            }
            
        }
    }
    
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
        
        
        // title with image cell
        if let nameWithImageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .nameTitleWithImage, placeHolder: nil) as? NameTitleWithImageCell {
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                nameWithImageCell.displayedValue = vm.title
            }
            
            nameWithImageCell.expandDelegate = self
            nameWithImageCell.imageSelectionDelegate = self
            
            nameWithImageCell.valueChanged = {
                self.viewModel?.title = nameWithImageCell.nameTextField.text!
            }
            
            self.cells.append(nameWithImageCell)
        }
        
        // Date cell
        if let dateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .datePicker, placeHolder: nil) as? ShineDatePickerCell {
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                dateCell.date = vm.startTime
            }
            
            dateCell.expandDelegate = self
            dateCell.selectionDelegate = self
            dateCell.getIndexPath = {
                return self.getIndexPathOfCell(dateCell)
            }
            
            dateCell.valueChanged = {
                self.viewModel?.startTime = dateCell.date
            }
            
            cells.append(dateCell)
        }
        
//        if let dateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .datePicker, placeHolder: nil) as? DatePickerCell{
//            
//            dateCell.expandDelegate = self
//            
////            dateCell.viewController = self
////            dateCell.tableView = self.tableView
////            
////            if let dependentCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .datePicker, placeHolder: nil) as? DatePickerFormCell {
////                
////                dependentCell.parentCell = dateCell
////                dateCell.dependentCells = [dependentCell]
////                dateCell.getIndexPath = {
////                    return self.getIndexPathOfCell(dateCell)
////                }
////            }
////            
////            dateCell.valueChanged = {
////                self.updateCellsWithDependentsOfCell(dateCell)
////                print("DAteCell change is not applicaple")
////                
////            }
//            
//            cells.append(dateCell)
//            
//        }
        
        // Description
        if let aboutCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .info, placeHolder: nil) as? TextViewFormCell{
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                aboutCell.displayedValue = vm.description
            }
            
            aboutCell.expandDelegate = self // Expanding cell delegate
            aboutCell.selectionDelegate = self
            aboutCell.getIndexPath = {
                return self.getIndexPathOfCell(aboutCell)
            }           
            
            aboutCell.valueChanged = {
                self.viewModel?.description = aboutCell.textView.text
                print("DAteCell change is not applicaple")
                
            }
            
            self.cells.append(aboutCell)
            
        }
        
        
        // Location cell
        if let locationCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .location, placeHolder: nil) as? LocationFormCell{
            
            locationCell.viewController = self
            locationCell.valueChanged = {
                print("Value change is not applicaple")
                
            }
            
            cells.append(locationCell)
            
        }
        
        
        
        // URL
        if let urlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .url, placeHolder: nil) as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            if self.viewModel != nil {
                urlCell.displayedValue = self.viewModel!.webUrl
            }
            
            urlCell.changeKeyboardType(.URL)
            
            urlCell.valueChanged = {
                self.viewModel?.webUrl = urlCell.textField.text!
            }
            
            self.cells.append(urlCell)
            
        }
        
        // Event type
        if let eventTypeCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .picker, placeHolder: "Event Type") as? PickerFormCell {
            
            if let vm = self.viewModel, vm.mode == .edit {
                eventTypeCell.selectedValue = (vm.eventType?.rawValue)!
            }
            
            eventTypeCell.expandDelegate = self
            eventTypeCell.selectionDelegate = self
            eventTypeCell.items = EventType.allCases()
            eventTypeCell.valueChanged = {
                self.viewModel?.eventType = EventType(rawValue: eventTypeCell.selectedValue)
            }
            
            eventTypeCell.getIndexPath = {
                return self.getIndexPathOfCell(eventTypeCell)
            }
            
            self.cells.append(eventTypeCell)
        }
        
        // Dance level
        if let danceLevelCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .picker, placeHolder: "Dance Level") as? PickerFormCell {
            
            if let vm = self.viewModel, vm.mode == .edit {
                danceLevelCell.selectedValue = (vm.eventType?.rawValue)!
            }
            
            danceLevelCell.expandDelegate = self
            danceLevelCell.selectionDelegate = self
            danceLevelCell.items = DanceLevel.allCases()
            danceLevelCell.valueChanged = {
                self.viewModel?.danceLevel = DanceLevel(rawValue: danceLevelCell.selectedValue)
            }
            
            danceLevelCell.getIndexPath = {
                return self.getIndexPathOfCell(danceLevelCell)
            }
            
            self.cells.append(danceLevelCell)
        }
        
        
        
        // 
        
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
        self.configureImagePickerController()
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
        self.tableView.allowsSelection = true
        
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
    
    private func configureImagePickerController(){
        
        self.imagePickerController.delegate = self // UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = false
        
    }
    
    func createEditEvent(){
        self.viewModel?.create()
    }
    
    func cancelCreateEditEvent() {
        print("create Event")
        self.viewModel?.cancel()
    }

}

extension EditCreateEventViewController : UIImagePickerControllerDelegate {
    
    // TODO: Check for this error when the image is loaded.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let index = self.cells.index(where: {$0 is NameTitleWithImageCell}) {
            
            if let cell = self.cells[index] as? NameTitleWithImageCell {
                cell.eventImageView.image = selectedImage
                cell.imagePicked()
                print("image picked")
            }
            
            
        } else {
            print("Exception")
        }
        
        //self.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Not required but expected to implement
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditCreateEventViewController : CellWithImageSelectorDelegate{
    
    func cellTappedForImageSelection(_ cell: BaseFormCell) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
        
        if self.cells[indexPath.row] is NameTitleWithImageCell {
            return self.nameWithImageCellHeight
        }
        
        if self.cells[indexPath.row] is TextViewFormCell {
            return self.textViewHeight
        }
        
        if let cell = self.cells[indexPath.row] as? BaseFormCell {
            return cell.designatedHeight
        }
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row is selected: \(indexPath.row)")
        
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
    
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?) {
        //expandingCellHeight = height
        
        if cell is TextViewFormCell {
            self.textViewHeight = height + 20
        }
        
        if cell is NameTitleWithImageCell {
            self.nameWithImageCellHeight = self.nameWithImageCellHeight + height
        }
        
        if cell is DatePickerCell {
            self.datePickerCellHeight = self.datePickerCellHeight + height
        }
        
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
extension EditCreateEventViewController : CellSelectionDelegate{
    
    func cellSelectionChanged(_ cell: BaseFormCell, state: SelectionState, indexPath: IndexPath?) {
        if self.activeIndex != indexPath {
            self.activeIndex = indexPath
        }
        
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
