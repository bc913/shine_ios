//
//  EditCreateOrganizationViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/24/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

struct FormSectionItem{
    var cells = [BaseFormCell]()
    var title : String = ""
    var sectionIndex : Int = 0
}

class EditCreateOrganizationViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    // This is a hack to update texview dynamically when content of the text view is larger than its container cell size
    var textViewHeight : CGFloat = 150.0
    
    // Cell height for nameWithImage cell
    var nameWithImageCellHeight : CGFloat = 66.0
    
    fileprivate var isLoaded : Bool = false
    
    // Image picker controller for nameWithImagecell
    var imagePickerController = UIImagePickerController()
    
    // ACtive selection
    var activeIndex : IndexPath? {
        willSet{
            if let index = self.activeIndex {
                self.cells[index.row].clearCellState()
            }
            
        }
    }
    
    // VM
    var viewModel : OrganizationViewModelType? {
        
        willSet{
            viewModel?.viewDelegate = nil
        }
        didSet{
            viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
    }
    
    fileprivate func refreshDisplay(){
        guard self.isLoaded else { return }
        
        self.title = "Create Organization"
        
        self.tableView?.reloadData()
        
    }
    
    /// The cells to display in the table.
    var cells = [BaseFormCell]()
    
    
    // Sections
    var formSections = [FormSectionItem]()
    
    
    private func constructCells(){
        
        // Name & photo
        
        var nameSection = FormSectionItem()
        nameSection.title = "Name"
        nameSection.sectionIndex = 0
        
        if let nameWithImageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .nameTitleWithImage, placeHolder: nil) as? NameTitleWithImageCell {
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                nameWithImageCell.displayedValue = vm.name!
            }
            
            nameWithImageCell.expandDelegate = self
            nameWithImageCell.imageSelectionDelegate = self
            nameWithImageCell.selectionDelegate = self
            
            nameWithImageCell.valueChanged = {
                self.viewModel?.name = nameWithImageCell.nameTextField.text!
            }
            
            self.cells.append(nameWithImageCell)
        }
        
        // Info
        
        if let aboutCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextView, placeHolder: "Tell us about your dance organization") as? ShineTextViewCell{
            
            // Initialize the form if it is in edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                aboutCell.displayedValue = vm.about ?? ""
            }
            
            aboutCell.expandDelegate = self // Expanding cell delegate
            aboutCell.selectionDelegate = self
            aboutCell.getIndexPath = {
                return self.getIndexPathOfCell(aboutCell)
            }
            
            aboutCell.valueChanged = {
                self.viewModel?.about = aboutCell.textView.text
            }
            
            self.cells.append(aboutCell)
        }
        
        // Contact
        
        if let emailCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextField, placeHolder: "E-mail") as? ShineTextFieldCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                emailCell.displayedValue = vm.contactInfo.email
            }
            
            emailCell.selectionDelegate = self
            emailCell.getIndexPath = {
                return self.getIndexPathOfCell(emailCell)
            }
            
            emailCell.valueChanged = {
                self.viewModel?.contactInfo.email = emailCell.textField.text!
            }
            emailCell.changeKeyboardType(.emailAddress)
            self.cells.append(emailCell)
        }
        
        if let phoneCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextField, placeHolder: "Phone") as? ShineTextFieldCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                phoneCell.displayedValue = vm.contactInfo.phone
            }
            phoneCell.selectionDelegate = self
            phoneCell.getIndexPath = {
                return self.getIndexPathOfCell(phoneCell)
            }
            
            phoneCell.changeKeyboardType(.phonePad)
            phoneCell.valueChanged = {
                self.viewModel?.contactInfo.phone = phoneCell.textField.text!
            }

            self.cells.append(phoneCell)
        }
        
        if let linkCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextField, placeHolder: "Url") as? ShineTextFieldCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                linkCell.displayedValue = vm.contactInfo.website
            }
            
            linkCell.selectionDelegate = self
            linkCell.getIndexPath = {
                return self.getIndexPathOfCell(linkCell)
            }
            
            linkCell.valueChanged = {
                self.viewModel?.contactInfo.website = linkCell.textField.text!
            }
            
            linkCell.changeKeyboardType(.URL)
            self.cells.append(linkCell)
        }
        
        if let facebookUrlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextField, placeHolder: "Facebook") as? ShineTextFieldCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                facebookUrlCell.displayedValue = vm.contactInfo.facebookUrl
            }
            
            facebookUrlCell.selectionDelegate = self
            facebookUrlCell.getIndexPath = {
                return self.getIndexPathOfCell(facebookUrlCell)
            }
            
            facebookUrlCell.valueChanged = {
                self.viewModel?.contactInfo.facebookUrl = facebookUrlCell.textField.text!
            }
            
            facebookUrlCell.changeKeyboardType(.URL)
            
            self.cells.append(facebookUrlCell)
        }
        
        
        if let instagramUrlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .shineTextField, placeHolder: "Instagram") as? ShineTextFieldCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                instagramUrlCell.displayedValue = vm.contactInfo.instagramUrl
            }
            
            instagramUrlCell.selectionDelegate = self
            instagramUrlCell.getIndexPath = {
                return self.getIndexPathOfCell(instagramUrlCell)
            }
            
            instagramUrlCell.valueChanged = {
                self.viewModel?.contactInfo.instagramUrl = instagramUrlCell.textField.text!
            }
            
            instagramUrlCell.changeKeyboardType(.URL)
            
            self.cells.append(instagramUrlCell)
        }
        
        // Dance sepcific information
        var danceSection = FormSectionItem(cells: [BaseFormCell](), title: "Dance", sectionIndex: 3)
        
        if let hasClassForKidsCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Classes for kids") as? ShineSwitchCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                hasClassForKidsCell.displayedValue = vm.hasClassForKids
            }
            
            hasClassForKidsCell.selectionDelegate = self
            hasClassForKidsCell.getIndexPath = {
                return self.getIndexPathOfCell(hasClassForKidsCell)
            }
            
            hasClassForKidsCell.valueChanged = {
                self.viewModel?.hasClassForKids = hasClassForKidsCell.isOn
                
            }
            
            self.cells.append(hasClassForKidsCell)
            
        }
        
        if let hasPrivateClassCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Private Class") as? ShineSwitchCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                hasPrivateClassCell.displayedValue = vm.hasPrivateClass
            }
            
            hasPrivateClassCell.selectionDelegate = self
            hasPrivateClassCell.getIndexPath = {
                return self.getIndexPathOfCell(hasPrivateClassCell)
            }
            
            hasPrivateClassCell.valueChanged = {
                self.viewModel?.hasPrivateClass = hasPrivateClassCell.isOn
                
            }
            
            self.cells.append(hasPrivateClassCell)
            
        }
        
        if let hasWeddingPackageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Wedding package/classes") as? ShineSwitchCell{
            
            // Initialize if it is edit mode
            if let vm = self.viewModel, vm.mode == .edit {
                hasWeddingPackageCell.displayedValue = vm.hasWeddingPackage
            }
            
            hasWeddingPackageCell.selectionDelegate = self
            hasWeddingPackageCell.getIndexPath = {
                return self.getIndexPathOfCell(hasWeddingPackageCell)
            }
            
            hasWeddingPackageCell.valueChanged = {
                self.viewModel?.hasWeddingPackage = hasWeddingPackageCell.isOn
                
            }
            
            self.cells.append(hasWeddingPackageCell)
            
            
        }
    }
    
    
//    /// Insert or remove cells into the cells list per the current value of a SwitchCell object.
//    func updateCellsWithDependentsOfCell(_ cell: DateFormCell, sectionIndex : Int = 0) {
//        // Multiple sections. You have to hard code the corresponding cells array
//        
//        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
//        {
//            let index = (indexPath as NSIndexPath).row + 1
//            if cell.tapState {
//                self.formSections[sectionIndex].cells.insert(contentsOf: cell.dependentCells as [BaseFormCell], at: index)
//            }
//            else {
//                let removeRange = index..<(index + cell.dependentCells.count)
//                self.formSections[sectionIndex].cells.removeSubrange(removeRange)
//            }
//        }
//        
//        
//        //Single section
//        
//        //        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
//        //        {
//        //            let index = (indexPath as NSIndexPath).row + 1
//        //            if cell.tapState {
//        //                cells.insert(contentsOf: cell.dependentCells as [BaseFormCell], at: index)
//        //            }
//        //            else {
//        //                let removeRange = index..<(index + cell.dependentCells.count)
//        //                cells.removeSubrange(removeRange)
//        //            }
//        //        }
//    }
    
    /// Return the index of a given cell in the cells list.
    func getIndexPathOfCell(_ cell: UITableViewCell) -> IndexPath? {
        
        // Multiple section
//        for sectionItem in self.formSections {
//            if let row = sectionItem.cells.index(where: { $0 == cell }) {
//                return IndexPath(row: row, section: sectionItem.sectionIndex)
//            }
//        }
//        return nil
        
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
        
        // Hide empty unused cells
        self.tableView.tableFooterView = UIView()
        
        //self.tableView?.estimatedRowHeight = 100 // Delegate method overwrites this
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCreateOrganizationProfile))
        
        // Done
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createOrganizationProfile))
    }
    
    private func configureImagePickerController(){
        
        self.imagePickerController.delegate = self // UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = false
        
    }
    
    func cancelCreateOrganizationProfile(){
        self.viewModel?.cancel()
    }
    
    func createOrganizationProfile() {
        print("create ORganization")
        self.viewModel?.create()
    }

}

// UITableViewDataSource
extension EditCreateOrganizationViewController : UITableViewDataSource {
    
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
extension EditCreateOrganizationViewController : UITableViewDelegate {
    
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

// MARK: textview dynamic expansion delegate
extension EditCreateOrganizationViewController: ExpandingCellDelegate {
    
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?) {
        //expandingCellHeight = height
        
        if cell is NameTitleWithImageCell {
            self.nameWithImageCellHeight = self.nameWithImageCellHeight + height
        }
        
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

// MARK: CellSelectionDelegate
extension EditCreateOrganizationViewController : CellSelectionDelegate{
    
    func cellSelectionChanged(_ cell: BaseFormCell, state: SelectionState, indexPath: IndexPath?) {
        if self.activeIndex != indexPath {
            self.activeIndex = indexPath
        }
        
    }
}

extension EditCreateOrganizationViewController : UIImagePickerControllerDelegate {
    
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

extension EditCreateOrganizationViewController : CellWithImageSelectorDelegate{
    
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


fileprivate extension EditCreateOrganizationViewController {
    
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

extension EditCreateOrganizationViewController : OrganizationViewModelViewDelegate{
    func organizationInfoDidChange(viewModel: OrganizationViewModelType) {
        self.refreshDisplay()
        //self.tableView.reloadData()
    }
    
    func organizationCreationDidSuccess(viewModel: OrganizationViewModelType){
        self.dismiss(animated: true, completion: nil)
    }
    
    func organizationCreationDidCancelled(viewModel: OrganizationViewModelType) {
        self.dismiss(animated: true, completion: nil)
    }
}

