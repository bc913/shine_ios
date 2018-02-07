//
//  ShineTextViewCell.swift
//  OneDance
//
//  Created by Burak Can on 2/6/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class ShineTextViewCell: BaseFormCell {

    
    /// Textfield
    var textView = UITextView()
    
    /// title for the cell
    var placeHolder : String?{
        didSet{
            self.textView.text = placeHolder
        }
    }
    
    /// Displayed state for the switch control
    var displayedValue : String = "" {
        didSet{
            self.textView.text = displayedValue
        }
    }
    
    /// Initial height
    var actualHeight : CGFloat = CGFloat(150.0)
    
    override var designatedHeight: CGFloat {
        return self.actualHeight
    }
    
    fileprivate func setup(){
        
        self.clipsToBounds = false
        self.autoresizesSubviews = true
        
        self.contentView.clipsToBounds = true
        self.contentView.autoresizesSubviews = true
        
        let views = [textView]
        for view in views {
            self.contentView.addSubview(view)
            view.clipsToBounds = true
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.configureLayout()
        
        // Configure textfield
        self.textView.delegate = self
        self.textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Implement placeholder
        self.textView.textColor = UIColor.lightGray
        
        //
        self.isCollapsible = false
    }
    
    private func configureLayout(){
        
        // Left label.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: textView,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
        ])
        
        
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ShineTextViewCell.identifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    
    /// Expand delegate
    func calculateTextViewHeight(_ textView: UITextView) -> CGFloat{
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = textView.frame
        
        let height : CGFloat = newSize.height > self.designatedHeight ? newSize.height : self.designatedHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        
        let cellHeight = self.frame.size.height
        print("cellHeight: \(cellHeight)")
        
        let contentHeight = self.contentView.frame.size.height
        print("contentHeight: \(contentHeight)")
        
        
        //print("Container height: \(self.contentContainer.frame.size.height)")
        print("TextView Height: \(textView.frame.size.height)")
        
        return newFrame.height
    }
    
    
    override func clearCellState() {
        self.textView.endEditing(true)
        super.clearCellState()
    }
    
}


extension ShineTextViewCell : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("TextView user started typing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        self.updateCellSelection()
        self.notifyTableView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeHolder
            textView.textColor = UIColor.lightGray
        }
        
        self.valueChanged?()
        print("TextView user stopped typing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = calculateTextViewHeight(textView)
        
        if height > self.actualHeight, let indexPath = getIndexPath?() {
            print("height: \(height)")
            print("actual height: \(self.actualHeight)")
            self.actualHeight = height
            self.expandDelegate?.updateCellHeight(cell: self, height: height,indexPath: indexPath)
        }
    }
}
