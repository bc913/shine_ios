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

class EditCreateOrganizationViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!

    // This is a hack to update texview dynamically when content of the text view is larger than its container cell size
    var textViewHeight : CGFloat = 150.0
    
    fileprivate var isLoaded : Bool = false
    
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
    // SectionCells
    var nameCells = [BaseFormCell]()
    var infoCells = [BaseFormCell]()
    var contactCells = [BaseFormCell]()
    var danceCells = [BaseFormCell]()
    
    
    private func constructCells(){
        
        // Name & photo
        
        var nameSection = FormSectionItem()
        nameSection.title = "Name"
        nameSection.sectionIndex = 0
        
        if let cell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .nameTitle, placeHolder: nil) as? NameTitleFormCell {
            
            // Initialize the form
            cell.displayedValue = self.viewModel?.name ?? ""
            
            cell.valueChanged = {
                self.viewModel?.name = cell.textField.text!
            }
            
            self.nameCells.append(cell)
        }
        
        nameSection.cells = self.nameCells
        formSections.append(nameSection)
        
        // Info
        var infoSection = FormSectionItem()
        infoSection.title = "About"
        infoSection.sectionIndex = 1
        
        if let aboutCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .info, placeHolder: nil) as? TextViewFormCell{
            
            aboutCell.expandDelegate = self // Expanding cell delegate
            aboutCell.getIndexPath = {
                return self.getIndexPathOfCell(aboutCell)
            }
            
            // Initialize the form if it is in edit mode
            aboutCell.displayedValue = self.viewModel?.about ?? ""
            
            aboutCell.valueChanged = {
                self.viewModel?.about = aboutCell.textView.text
                print("DAteCell change is not applicaple")
                
            }
            
            self.infoCells.append(aboutCell)
            
        }
        
        //        if let dateCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .date, placeHolder: nil) as? DateFormCell{
        //
        //            dateCell.viewController = self
        //            dateCell.tableView = self.tableView
        //
        //            if let dependentCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .datePicker, placeHolder: nil) as? DatePickerFormCell {
        //
        //                dependentCell.parentCell = dateCell
        //                dateCell.dependentCells = [dependentCell]
        //                dateCell.getIndexPath = {
        //                    return self.getIndexPathOfCell(dateCell)
        //                }
        //            }
        //
        //            dateCell.valueChanged = {
        //                self.updateCellsWithDependentsOfCell(dateCell, sectionIndex: infoSection.sectionIndex)
        //                print("DAteCell change is not applicaple")
        //
        //            }
        //
        //            infoCells.append(dateCell)
        //
        //        }
        
        infoSection.cells = self.infoCells
        formSections.append(infoSection)
        
        // Contact
        var contactSection = FormSectionItem()
        contactSection.title = "Contact"
        contactSection.sectionIndex = 2
        
        
        if let emailCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .email, placeHolder: nil) as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            emailCell.displayedValue = self.viewModel?.contactInfo.email ?? ""
            
            emailCell.valueChanged = {
                self.viewModel?.contactInfo.email = emailCell.textField.text!
            }
            emailCell.changeKeyboardType(.emailAddress)
            self.contactCells.append(emailCell)
        }
        
        if let phoneCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .phoneNumber, placeHolder: nil) as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            phoneCell.displayedValue = self.viewModel?.contactInfo.phone ?? ""
            
            phoneCell.valueChanged = {
                self.viewModel?.contactInfo.phone = phoneCell.textField.text!
            }
            phoneCell.changeKeyboardType(.phonePad)
            self.contactCells.append(phoneCell)
        }
        
        if let linkCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .url, placeHolder: nil) as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            linkCell.displayedValue = self.viewModel?.contactInfo.website ?? ""
            
            linkCell.valueChanged = {
                self.viewModel?.contactInfo.website = linkCell.textField.text!
            }
            linkCell.changeKeyboardType(.URL)
            self.contactCells.append(linkCell)
        }
        
        if let facebookUrlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .url, placeHolder: "Facebook (Optional)") as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            facebookUrlCell.displayedValue = self.viewModel?.contactInfo.facebookUrl ?? ""
            
            facebookUrlCell.valueChanged = {
                self.viewModel?.contactInfo.facebookUrl = facebookUrlCell.textField.text!
            }
            facebookUrlCell.changeKeyboardType(.URL)
            self.contactCells.append(facebookUrlCell)
        }
        
        
        if let instagramUrlCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .url, placeHolder: "Instagram (Optional)") as? TextFieldFormCell{
            
            // Initialize if it is edit mode
            instagramUrlCell.displayedValue = self.viewModel?.contactInfo.instagramUrl ?? ""
            
            instagramUrlCell.valueChanged = {
                self.viewModel?.contactInfo.instagramUrl = instagramUrlCell.textField.text!
            }
            instagramUrlCell.changeKeyboardType(.URL)
            self.contactCells.append(instagramUrlCell)
        }
        
        
        
        
        contactSection.cells = self.contactCells
        formSections.append(contactSection)
        
        
        // Dance sepcific information
        var danceSection = FormSectionItem(cells: [BaseFormCell](), title: "Dance", sectionIndex: 3)
        
        if let hasClassForKidsCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Classes for kids") as? SwitchFormCell{
            
            //
            hasClassForKidsCell.displayedValue = self.viewModel?.hasClassForKids ?? false
            
            hasClassForKidsCell.valueChanged = {
                self.viewModel?.hasClassForKids = hasClassForKidsCell.isOn
                
            }
            
            self.danceCells.append(hasClassForKidsCell)
            
        }
        
        if let hasPrivateClassCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Private Class") as? SwitchFormCell{
            
            //
            hasPrivateClassCell.displayedValue = self.viewModel?.hasPrivateClass ?? false
            
            hasPrivateClassCell.valueChanged = {
                self.viewModel?.hasPrivateClass = hasPrivateClassCell.isOn
                
            }
            
            self.danceCells.append(hasPrivateClassCell)
            
        }
        
        if let hasWeddingPackageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceOrganization, type: .switchType, placeHolder: "Wedding package/classes") as? SwitchFormCell{
            
            //
            hasWeddingPackageCell.displayedValue = self.viewModel?.hasWeddingPackage ?? false
            
            hasWeddingPackageCell.valueChanged = {
                self.viewModel?.hasWeddingPackage = hasWeddingPackageCell.isOn
                
            }
            
            self.danceCells.append(hasWeddingPackageCell)
            
        }
        
        danceSection.cells = self.danceCells
        formSections.append(danceSection)
        
        
        
        /*
         if let hasClassForKidsCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .switchType, placeHolder: "Has Classes for kids") as? SwitchFormCell{
         hasClassForKidsCell.valueChanged = {
         self.viewModel?.hasClassForKids = hasClassForKidsCell.isOn
         
         }
         
         cells.append(hasClassForKidsCell)
         
         }
         
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
         
         if let locationCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createOrganizationProfile, type: .location, placeHolder: nil) as? LocationFormCell{
         
         locationCell.viewController = self
         locationCell.valueChanged = {
         print("Value change is not applicaple")
         
         }
         
         cells.append(locationCell)
         
         }
         
         */
    }
    
    /// Insert or remove cells into the cells list per the current value of a SwitchCell object.
    func updateCellsWithDependentsOfCell(_ cell: DateFormCell, sectionIndex : Int = 0) {
        // Multiple sections. You have to hard code the corresponding cells array
        
        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
        {
            let index = (indexPath as NSIndexPath).row + 1
            if cell.tapState {
                self.formSections[sectionIndex].cells.insert(contentsOf: cell.dependentCells as [BaseFormCell], at: index)
            }
            else {
                let removeRange = index..<(index + cell.dependentCells.count)
                self.formSections[sectionIndex].cells.removeSubrange(removeRange)
            }
        }
        
        
        //Single section
        
        //        if let indexPath = getIndexPathOfCell(cell), !cell.dependentCells.isEmpty
        //        {
        //            let index = (indexPath as NSIndexPath).row + 1
        //            if cell.tapState {
        //                cells.insert(contentsOf: cell.dependentCells as [BaseFormCell], at: index)
        //            }
        //            else {
        //                let removeRange = index..<(index + cell.dependentCells.count)
        //                cells.removeSubrange(removeRange)
        //            }
        //        }
    }
    
    /// Return the index of a given cell in the cells list.
    func getIndexPathOfCell(_ cell: UITableViewCell) -> IndexPath? {
        
        for sectionItem in self.formSections {
            if let row = sectionItem.cells.index(where: { $0 == cell }) {
                return IndexPath(row: row, section: sectionItem.sectionIndex)
            }
        }
        
        return nil
        
        //Single section
        //        if let row = cells.index(where: { $0 == cell }) {
        //            return IndexPath(row: row, section: 0)
        //        }
        //        return nil
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCreateOrganizationProfile))
        
        // Done
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createOrganizationProfile))
    }
    
    func cancelCreateOrganizationProfile(){
        self.viewModel?.cancelEditCreateOrganization()
    }
    
    func createOrganizationProfile() {
        print("create ORganization")
        self.viewModel?.createOrganizationProfile()
    }

}

// UITableViewDataSource
extension EditCreateOrganizationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.formSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectIndex = section
        
        if let index = self.formSections.index(where: {$0.sectionIndex == section}) {
            sectIndex = index
        }
        
        return self.formSections[sectIndex].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formSections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.formSections[indexPath.section].cells[indexPath.row]
    }
    
    
}

// UITableViewDelegate
extension EditCreateOrganizationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.formSections[indexPath.section].cells[indexPath.row] is TextViewFormCell {
            return self.textViewHeight
        }
        
        if let cell = self.formSections[indexPath.section].cells[indexPath.row] as? BaseFormCell {
            return cell.designatedHeight
        }
        return 100.0
    }
    
}

// MARK: textview dynamic expansion delegate
extension EditCreateOrganizationViewController: ExpandingCellDelegate {
    
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?) {
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

