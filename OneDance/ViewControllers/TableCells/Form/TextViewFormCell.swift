//
//  TextViewFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/19/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit



class TextViewFormCell: BaseFormCell {

    @IBOutlet weak var textView: UITextView!
        
    var placeHolder : String? {
        didSet{
            self.textView.text = placeHolder
        }
    }
    
    var displayedValue : String = "" {
        didSet {
            self.textView.text = displayedValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.delegate = self
        self.textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Implement placeholder
        
        self.textView.textColor = UIColor.lightGray
        
        //
        self.isCollapsible = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        print("TextView cell is selected: \(self.isSelected)")
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    
    func calculateTextViewHeight(_ textView: UITextView) -> CGFloat{
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = textView.frame
        
        let height : CGFloat = newSize.height > self.designatedHeight ? newSize.height : self.designatedHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
    
    override func clearCellState() {
        self.textView.endEditing(true)
        super.clearCellState()
    }
    
}

extension TextViewFormCell : UITextViewDelegate {
    
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
        
        print("TextView user stopped typing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = calculateTextViewHeight(textView)
        
        if height > self.designatedHeight, let indexPath = getIndexPath?() {
            
            print("Osmaaaaaaan")
            self.expandDelegate?.updateCellHeight(cell: self, height: height,indexPath: indexPath)
            
            
        }
    }
}
