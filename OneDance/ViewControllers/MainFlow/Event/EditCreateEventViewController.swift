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
    weak var nameCell : NameTitleWithImageCell!
    weak var startDateCell : ShineDatePickerCell!
    weak var endDateCell : ShineDatePickerCell!
    weak var aboutCell : ShineTextViewCell!
    weak var locationCell : ShineLocationCell!
    
    weak var urlCell : ShineTextFieldCell!
    
    weak var eventTypeCell : PickerFormCell!
    weak var danceLevelCell : PickerFormCell!
    
    weak var feePolicyCell : ShineSwitchCell!
    weak var feeTypeCell : ShineTextFieldCell!
    weak var feeValueCell : ShineTextFieldCell!
    weak var sessionsCell : ShineTextFieldCell!
    weak var feeDescCell : ShineTextViewCell!
    
    weak var dressCodeCell : ShineSwitchCell!
    weak var partnerReqCell : ShineSwitchCell!
    weak var hasPerfCell : ShineSwitchCell!
    weak var hasWorkshopCell : ShineSwitchCell!
    
    weak var contactPersonCell : ShineSwitchCell!
    weak var contactPersonNameCell : ShineTextFieldCell!
    weak var contactPersonEmailCell : ShineTextFieldCell!
    weak var contactPersonPhoneCell : ShineTextFieldCell!
    
    private func constructCells(){
        
        // title with image cell
        let nameWithImageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .nameTitleWithImage, placeHolder: nil) as! NameTitleWithImageCell
        self.nameCell = nameWithImageCell
            
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit {
            self.nameCell.displayedValue = vm.title
        }
        
        self.nameCell.expandDelegate = self
        self.nameCell.imageSelectionDelegate = self
        self.nameCell.selectionDelegate = self
        
        self.nameCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }

            strongSelf.viewModel?.title = strongSelf.nameCell.nameTextField.text!
        }
        
        self.cells.append(self.nameCell)
        
        
        // Start Date cell
        let dateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .datePicker, placeHolder: "Start Time") as! ShineDatePickerCell
        self.startDateCell = dateCell
        
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit {
            startDateCell.date = vm.startTime
        }
        
        startDateCell.expandDelegate = self
        startDateCell.selectionDelegate = self
        startDateCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.startDateCell)
        }
        
        startDateCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.startTime = strongSelf.startDateCell.date
        }
        
        cells.append(startDateCell)
        
        
        // End Date cell
        let eventEndDateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .datePicker, placeHolder: "End Time") as! ShineDatePickerCell
        self.endDateCell = eventEndDateCell
        
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit {
            endDateCell.date = vm.endTime
        }
        
        endDateCell.expandDelegate = self
        endDateCell.selectionDelegate = self
        endDateCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.endDateCell)
        }
        
        endDateCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.endTime = strongSelf.endDateCell.date
        }
        
        cells.append(endDateCell)
        
        
        // Description
        let eventAboutCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextView, placeHolder: "Tell us about your event details") as! ShineTextViewCell
        self.aboutCell = eventAboutCell
        
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit {
            aboutCell.displayedValue = vm.description
        }
        
        aboutCell.expandDelegate = self // Expanding cell delegate
        aboutCell.selectionDelegate = self
        aboutCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.aboutCell)
        }           
        
        aboutCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.description = strongSelf.aboutCell.textView.text
        }
        
        self.cells.append(aboutCell)
            
        
        
        // Location cell
        let eventLocationCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .location, placeHolder: nil) as! ShineLocationCell
        self.locationCell = eventLocationCell
        
        
        if let vm = self.viewModel, vm.mode == .edit, vm.location != nil {
            locationCell.displayedValue = vm.location!.name
        }
        
        locationCell.selectionDelegate = self
        locationCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.locationCell)
        }
        
        locationCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.location?.name = strongSelf.locationCell.rightLabel.text!
        }
        
        cells.append(locationCell)
            
        
        
        // URL
        let eventUrlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Url") as! ShineTextFieldCell
        self.urlCell = eventUrlCell
        
        // Initialize if it is edit mode
        if self.viewModel != nil {
            urlCell.displayedValue = self.viewModel!.webUrl
        }
        
        urlCell.selectionDelegate = self
        urlCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.urlCell)
        }
        
        urlCell.changeKeyboardType(.URL)
        urlCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.webUrl = strongSelf.urlCell.textField.text!
        }
        
        self.cells.append(urlCell)
        
        
        // Event type
        let evEventTypeCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .picker, placeHolder: "Event Type") as! PickerFormCell
        self.eventTypeCell = evEventTypeCell
        
        if let vm = self.viewModel, let type = vm.eventType {
            eventTypeCell.selectedValue = type.rawValue
        }
        
        eventTypeCell.expandDelegate = self
        eventTypeCell.selectionDelegate = self
        eventTypeCell.items = EventType.allCases()
        
        eventTypeCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.eventTypeCell)
        }
        
        eventTypeCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.eventType = EventType(rawValue: strongSelf.eventTypeCell.selectedValue)
        }
        self.cells.append(eventTypeCell)
        
        
        // Dance level
        let eventDanceLevelCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .picker, placeHolder: "Dance Level") as! PickerFormCell
        self.danceLevelCell = eventDanceLevelCell
        
        if let vm = self.viewModel, let level = vm.danceLevel {
            danceLevelCell.selectedValue = level.rawValue
        }
        
        danceLevelCell.expandDelegate = self
        danceLevelCell.selectionDelegate = self
        danceLevelCell.items = DanceLevel.allCases()
        danceLevelCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.danceLevelCell)
        }
        
        danceLevelCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.danceLevel = DanceLevel(rawValue: strongSelf.danceLevelCell.selectedValue)
        }
        self.cells.append(danceLevelCell)
        
        
        
        // Fee policy
        let evFeePolicyCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Fee") as! ShineSwitchCell
        self.feePolicyCell = evFeePolicyCell
        
        //
        if let vm = self.viewModel, let feePolicy = vm.feePolicy {
            feePolicyCell.displayedValue = true
        }
        
        feePolicyCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.feePolicyCell)
        }
        
        
        var dependentCells = [BaseFormCell]()
        
        // Fee type
        let evFeeTypeCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Type") as! ShineTextFieldCell
        self.feeTypeCell = evFeeTypeCell
        
        if let vm = self.viewModel, vm.mode == .edit, let feePolicy = vm.feePolicy {
            feeTypeCell.displayedValue = feePolicy.options[0].type
        }
        
        feeTypeCell.selectionDelegate = self
        
        feeTypeCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.feeTypeCell)
        }
        
        feeTypeCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.feePolicy?.options[0].type = strongSelf.feeTypeCell.textField.text!
        }
        
        dependentCells.append(feeTypeCell)
            
        
        // Fee Value
        let evFeeValueCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Cover") as! ShineTextFieldCell
        self.feeValueCell = evFeeValueCell
        
        if let vm = self.viewModel, let feePolicy = vm.feePolicy {
            feeValueCell.displayedValue = String(describing: feePolicy.options[0].value)
        }
        
        feeValueCell.selectionDelegate = self
        
        feeValueCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.feeValueCell)
        }
        
        feeValueCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.feePolicy?.options[0].value = Double(strongSelf.feeValueCell.textField.text!) ?? 0.0
        }
        
        feeValueCell.changeKeyboardType(.decimalPad)
        
        dependentCells.append(feeValueCell)
            
        // Number of sessions
        
        let evSessionsCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Sessions") as! ShineTextFieldCell
        self.sessionsCell = evSessionsCell
        
        if let vm = self.viewModel, let feePolicy = vm.feePolicy {
            sessionsCell.displayedValue = String(describing: feePolicy.options[0].numberOfSessions)
        }
        
        sessionsCell.selectionDelegate = self
        
        sessionsCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.sessionsCell)
        }
        
        sessionsCell.changeKeyboardType(.numberPad)
        sessionsCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.feePolicy?.options[0].numberOfSessions = Int(strongSelf.sessionsCell.textField.text!)
        }
        
        dependentCells.append(sessionsCell)
            
        
        
        // Description
        let descCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextView, placeHolder: "Tell about the event's fee policy") as! ShineTextViewCell
        self.feeDescCell = descCell
            
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit, let feePolicy = vm.feePolicy {
            feeDescCell.displayedValue = feePolicy.description ?? ""
        }
        
        feeDescCell.expandDelegate = self // Expanding cell delegate
        feeDescCell.selectionDelegate = self
        feeDescCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.feeDescCell)
        }
        
        feeDescCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.feePolicy?.description = strongSelf.feeDescCell.textView.text
            
        }
        
        dependentCells.append(feeDescCell)
            
        
        
        feePolicyCell.selectionDelegate = self
        feePolicyCell.dependentCells = dependentCells
        feePolicyCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.updateCellsWithDependentsOfCell(strongSelf.feePolicyCell)
            if strongSelf.feePolicyCell.isOn {
                strongSelf.viewModel?.feePolicy = FeePolicyItem()
            }
        }
        
        feePolicyCell.tableView = self.tableView
        self.cells.append(feePolicyCell)
            
        
        
        // Dresscode
        let evDressCodeCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Dress Code") as! ShineSwitchCell
        self.dressCodeCell = evDressCodeCell
        
        if self.viewModel != nil {
            dressCodeCell.displayedValue = self.viewModel!.hasDressCode
        }
        
        dressCodeCell.selectionDelegate = self
        dressCodeCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.dressCodeCell)
        }
        
        dressCodeCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.hasDressCode = strongSelf.dressCodeCell.isOn
        }
        
        self.cells.append(dressCodeCell)
            
        
        
        // partner Required
        let evPartnerReqCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Partner required") as! ShineSwitchCell
        self.partnerReqCell = evPartnerReqCell
        
        if self.viewModel != nil {
            partnerReqCell.displayedValue = self.viewModel!.partnerRequired
        }
        
        partnerReqCell.selectionDelegate = self
        partnerReqCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.partnerReqCell)
        }
        
        partnerReqCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.partnerRequired = strongSelf.partnerReqCell.isOn
        }
        
        self.cells.append(partnerReqCell)
            
        
        
        // HasPerformance
        let evHasPerfCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Performance") as! ShineSwitchCell
        self.hasPerfCell = evHasPerfCell
        
        if self.viewModel != nil {
            hasPerfCell.displayedValue = self.viewModel!.hasPerformance
        }
        
        hasPerfCell.selectionDelegate = self
        hasPerfCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.hasPerfCell)
        }
        
        hasPerfCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.hasPerformance = strongSelf.hasPerfCell.isOn
        }
        
        self.cells.append(hasPerfCell)
            
        
        
        // hasWorkshop
        let hasWSCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Workshop") as! ShineSwitchCell
        self.hasWorkshopCell = hasWSCell
        
        if self.viewModel != nil {
            hasWorkshopCell.displayedValue = self.viewModel!.hasWorkshop
        }
        
        hasWorkshopCell.selectionDelegate = self
        hasWorkshopCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.hasWorkshopCell)
        }
        
        hasWorkshopCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.hasWorkshop = strongSelf.hasWorkshopCell.isOn
        }
        
        self.cells.append(hasWorkshopCell)
            
        
        
        // Contact Person
        
        // Define dependent cells
        var contactDependentCells = [BaseFormCell]()
        
        
        // Contact person name
        let contactNameCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Name") as! ShineTextFieldCell
        self.contactPersonNameCell = contactNameCell
            
        if let vm = self.viewModel, let contactPerson = vm.contactPerson {
            contactPersonNameCell.displayedValue = contactPerson.name
        }
        
        contactPersonNameCell.selectionDelegate = self
        
        contactPersonNameCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.contactPersonNameCell)
        }
        
        contactPersonNameCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.contactPerson?.name = strongSelf.contactPersonNameCell.textField.text!
        }
        
        contactDependentCells.append(contactPersonNameCell)
            
        // Contact person email
        
        let emailCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "E-mail") as! ShineTextFieldCell
        self.contactPersonEmailCell = emailCell
        
        if let vm = self.viewModel, let contactPerson = vm.contactPerson {
            contactPersonEmailCell.displayedValue = contactPerson.email
        }
        
        contactPersonEmailCell.selectionDelegate = self
        
        contactPersonEmailCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.contactPersonEmailCell)
        }
        
        contactPersonEmailCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.contactPerson?.email = strongSelf.contactPersonEmailCell.textField.text!
        }
        
        contactPersonEmailCell.changeKeyboardType(.emailAddress)
        contactDependentCells.append(contactPersonEmailCell)
            
        // Contact person phone
        
        let phoneCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextField, placeHolder: "Phone") as! ShineTextFieldCell
        self.contactPersonPhoneCell = phoneCell
        
        if let vm = self.viewModel, let contactPerson = vm.contactPerson {
            contactPersonPhoneCell.displayedValue = contactPerson.phone
        }
        
        contactPersonPhoneCell.selectionDelegate = self
        
        contactPersonPhoneCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.contactPersonPhoneCell)
        }
        
        contactPersonPhoneCell.changeKeyboardType(.phonePad)
        
        contactPersonPhoneCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.contactPerson?.phone = strongSelf.contactPersonPhoneCell.textField.text!
        }
        
        contactDependentCells.append(contactPersonPhoneCell)
            
        
        // Contact person container
        let evContactPersonCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .switchType, placeHolder: "Contact Person") as! ShineSwitchCell
        self.contactPersonCell = evContactPersonCell
        //
        if self.viewModel != nil && self.viewModel!.contactPerson != nil {
            contactPersonCell.displayedValue = true
        }

        contactPersonCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }

            return strongSelf.getIndexPathOfCell(strongSelf.contactPersonCell)
        }
        contactPersonCell.selectionDelegate = self
        contactPersonCell.dependentCells = contactDependentCells
        
        contactPersonCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            

            if let vm = strongSelf.viewModel {
                if strongSelf.contactPersonCell.isOn {
                    if vm.contactPerson == nil {
                        strongSelf.viewModel!.contactPerson = ContactPersonItem()
                    } else{
                        strongSelf.viewModel!.contactPerson!.clear()
                    }
                } else { //!isOn
                    strongSelf.viewModel!.contactPerson = nil
                }
            }
            strongSelf.updateCellsWithDependentsOfCell(strongSelf.contactPersonCell)
        }
        
        
        contactPersonCell.tableView = self.tableView
        self.cells.append(contactPersonCell)
    }
    
    /// Insert or remove cells into the cells list per the current value of a SwitchCell object.
    func updateCellsWithDependentsOfCell(_ cell: BaseFormCell, sectionIndex : Int = 0) {
        // Multiple sections. You have to hard code the corresponding cells array
        
        //Single section
        
        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
        {
            let index = (indexPath as NSIndexPath).row + 1
            
            if let switchCell = cell as? ShineSwitchCell {
                
                if switchCell.isOn {
                    cells.insert(contentsOf: switchCell.dependentCells, at: index)
                }
                else {
                    let removeRange = index..<(index + cell.dependentCells.count)
                    cells.removeSubrange(removeRange)
                }
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
                self.viewModel?.imageData = UIImagePNGRepresentation(selectedImage)
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
    
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?) {
    
        
        if cell is NameTitleWithImageCell {
            self.nameWithImageCellHeight = self.nameWithImageCellHeight + height
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
    
    func cellSelectedForLocation(){
        self.viewModel?.requestLocation()
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
