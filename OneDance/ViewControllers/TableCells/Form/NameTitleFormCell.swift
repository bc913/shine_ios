//
//  NameTitleFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/14/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

final class NameTitleFormCell: BaseFormCell {

    @IBOutlet weak var textField: UITextField!
    
    var placeHolder : String?{
        didSet{
            self.textField.placeholder = placeHolder
        }
    }
    
    var displayedValue : String = "" {
        didSet{
            self.textField.text = displayedValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textField.delegate = self
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
    
}

extension NameTitleFormCell : UITextFieldDelegate {
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
