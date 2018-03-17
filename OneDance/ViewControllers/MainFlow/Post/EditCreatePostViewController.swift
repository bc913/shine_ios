//
//  EditCreatePostViewController.swift
//  OneDance
//
//  Created by Burak Can on 2/25/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class EditCreatePostViewController: UIViewController, UINavigationControllerDelegate {
    
    weak var tableView : UITableView!
    
    var viewModel : PostViewModel? {
        willSet{
            self.viewModel?.viewDelegate = nil
        }
    }
    
    // Active selection
    var activeIndex : IndexPath? {
        willSet{
            if let index = self.activeIndex {
                self.cells[index.row].clearCellState()
            }
            
        }
    }
    
    // Image picker controller for nameWithImagecell
    var imagePickerController = UIImagePickerController()
    // Cell height for nameWithImage cell
    var nameWithImageCellHeight : CGFloat = 66.0
    
    var cells = [BaseFormCell]()
    weak var photoCell : NameTitleWithImageCell!
    weak var textCell : ShineTextViewCell!
    
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
        self.title = "Create Post"
        
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureNavigationBar()
        self.registerKeyboardNotifications()
        self.configureImagePickerController()
        
        
        // Populate cells
        self.constructCells()
    }
    
    private func configureImagePickerController(){
        
        self.imagePickerController.delegate = self // UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = false
        
    }
    
    private func constructCells(){
        
        // title with image cell
        let nameWithImageCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .nameTitleWithImage, placeHolder: nil) as! NameTitleWithImageCell
        self.photoCell = nameWithImageCell
        
        // Initialize the form if it is in edit mode
//            if let vm = self.viewModel, vm.mode == .edit {
//                nameWithImageCell.displayedValue = vm.title
//            }
        
        photoCell.expandDelegate = self
        photoCell.imageSelectionDelegate = self
        photoCell.selectionDelegate = self
        
        photoCell.nameTextField.text = "Photo"
        photoCell.nameTextField.isEnabled = false
        
//            nameWithImageCell.valueChanged = {
//                self.viewModel?.title = nameWithImageCell.nameTextField.text!
//            }
        
        self.cells.append(photoCell)
        
        
        // Text
        let postTextCell = FormItemCellFactory.create(tableView: self.tableView, purpose: .createDanceEvent, type: .shineTextView, placeHolder: "Tell us about your event details") as! ShineTextViewCell
        self.textCell = postTextCell
        
        // Initialize the form if it is in edit mode
        if let vm = self.viewModel, vm.mode == .edit {
            textCell.displayedValue = vm.text
        }
        
        textCell.expandDelegate = self // Expanding cell delegate
        textCell.selectionDelegate = self
        textCell.getIndexPath = {[weak self] in
            
            guard let strongSelf = self else { return nil }
            return strongSelf.getIndexPathOfCell(strongSelf.textCell)
        }
        
        textCell.valueChanged = {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.text = strongSelf.textCell.textView.text
        }
        
        self.cells.append(textCell)
    }
    
    /// Return the index of a given cell in the cells list.
    func getIndexPathOfCell(_ cell: UITableViewCell) -> IndexPath? {
        
        //Single section
        if let row = cells.index(where: { $0 == cell }) {
            return IndexPath(row: row, section: 0)
        }
        return nil
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        // Create/Edit
        var createEditTitle : String = "Create"
        if self.viewModel?.mode == .edit {
            createEditTitle = "Edit"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: createEditTitle, style: .plain, target: self, action: #selector(createEdit))
    }
    
    func createEdit(){
        self.viewModel?.create()
    }
    
    func cancel(){
        self.viewModel?.cancel()
    }

}

// UITableViewDataSource
extension EditCreatePostViewController : UITableViewDataSource {
    
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
extension EditCreatePostViewController : UITableViewDelegate {
    
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
extension EditCreatePostViewController: ExpandingCellDelegate {
    
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
extension EditCreatePostViewController : CellSelectionDelegate{
    
    func cellSelectionChanged(_ cell: BaseFormCell, state: SelectionState, indexPath: IndexPath?) {
        if self.activeIndex != indexPath {
            self.activeIndex = indexPath
        }
        
    }
    
    func cellSelectedForLocation(){
        //self.viewModel?.requestLocation()
    }
}

fileprivate extension EditCreatePostViewController {
    
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

// MARK: ImagePicker
extension EditCreatePostViewController : UIImagePickerControllerDelegate {
    
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

extension EditCreatePostViewController : CellWithImageSelectorDelegate{
    
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

