//
//  ShineTextFieldCell.swift
//  OneDance
//
//  Created by Burak Can on 2/5/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class ShineTextFieldCell: BaseFormCell {

    /// Container for the content
    var contentContainer = UIView()
    
    /// Textfield
    var textField = UITextField()
    
    /// title for the cell
    var placeHolder : String?{
        didSet{
            self.textField.placeholder = placeHolder
        }
    }
    
    /// Displayed state for the switch control
    var displayedValue : String = "" {
        didSet{
            self.textField.text = displayedValue
        }
    }
    
    
    fileprivate func setup(){
        
        self.clipsToBounds = true
        
        let views = [contentContainer, textField]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.contentContainer.addSubview(self.textField)
        self.configureLayout()
        
        // Configure textfield
        self.textField.delegate = self
        self.textField.clearButtonMode = .whileEditing
        self.textField.borderStyle = .none

    }
    
    func changeKeyboardType(_ type: UIKeyboardType){
        self.textField.keyboardType = type
    }
    
    override func clearCellState() {
        self.textField.endEditing(true)
        print("textFieldClearCellState")
        super.clearCellState()
    }
    
    private func configureTappableCell(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellSelected(tapGestureRecognizer:)))
        
        self.contentContainer.isUserInteractionEnabled = true
        self.contentContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cellSelected(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil {
            print("Date picker tapped")
            self.updateCellSelection()
            self.notifyTableView()
        }
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ShineTextFieldCell.identifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func configureLayout(){
        // Layout
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: self.designatedHeight
            ),
        ])
        
        // Left label.
        self.contentContainer.addConstraints([
            NSLayoutConstraint(
                item: textField,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: textField,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: textField,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: textField,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
        ])
        
        
        
        
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }

}




// MARK: UITextFieldDelegate
extension ShineTextFieldCell : UITextFieldDelegate {
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateCellSelection()
        self.notifyTableView()
        print("textFieldDidBeginEditing")
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
