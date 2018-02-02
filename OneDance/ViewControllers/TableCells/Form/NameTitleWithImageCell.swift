//
//  NameTitleWithImageCell.swift
//  OneDance
//
//  Created by Burak Can on 1/28/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

protocol CellWithImageSelectorDelegate : class {
    func cellTappedForImageSelection(_ cell: BaseFormCell)
}

class NameTitleWithImageCell: BaseFormCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageSelector: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var imageSelectionDelegate : CellWithImageSelectorDelegate?
    
    var placeHolder : String?{
        didSet{
            self.nameTextField.placeholder = placeHolder
        }
    }
    
    var displayedValue : String = "" {
        didSet{
            self.nameTextField.text = displayedValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameTextField.delegate = self
        self.configureTappableImage()
    }
    
    private func configureTappableImage(){
        self.imageSelector.image = UIImage(named: "dancers")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eventImageTapped(tapGestureRecognizer:)))
        
        self.imageSelector.isUserInteractionEnabled = true
        self.imageSelector.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func eventImageTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view as? UIImageView) != nil {
            print("EventImage tapped")
            self.imageSelectionDelegate?.cellTappedForImageSelection(self)
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    override var designatedHeight : CGFloat{
        return 66.0
    }
    
    func imagePicked(){
        self.expandDelegate?.updateCellHeight(cell: self, height: 150, indexPath: nil)
    }
    
}

extension NameTitleWithImageCell : UITextFieldDelegate {
    /// Handle the event of the user finishing changing the value of the text field.
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        textField.resignFirstResponder()
        valueChanged?()
        
    }
    
    /// Dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        valueChanged?()
        return true
    }
}
