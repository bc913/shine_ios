//
//  TextFieldFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/19/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class TextFieldFormCell: BaseFormCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var placeHolder : String? {
        didSet{
            self.title.text = placeHolder
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textField.delegate = self
        self.textField.clearButtonMode = .whileEditing
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
    
    func changeKeyboardType(_ type: UIKeyboardType){
        self.textField.keyboardType = type
    }
    
    
}

extension TextFieldFormCell : UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.textAlignment = .left
        print("textFieldShouldBeginEditing")
        return true
    }
    
    /// Handle the event of the user finishing changing the value of the text field.
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        textField.resignFirstResponder()
//        textField.textAlignment = .right
        valueChanged?()
        
    }
    
    /// Dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
//        textField.textAlignment = .right
        return true
    }
    
}
