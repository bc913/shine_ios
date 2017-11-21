//
//  TextViewFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/19/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

protocol ExpandingCellDelegate : class {
    func updateCellHeight(height: CGFloat, indexPath: IndexPath)
}

class TextViewFormCell: BaseFormCell {

    @IBOutlet weak var textView: UITextView!
    weak var delegate : ExpandingCellDelegate?
    
    
    weak var tableView : UITableView?
    
    var placeHolder : String? {
        didSet{
            self.textView.text = placeHolder
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
    
    override var designatedHeight: CGFloat{
        get {
            return 150.0
        }
        
        set(newHeight) {
        }
        
    }
    
    /// A block to call to get the index path of this cell int its containing table.
    var getIndexPath: ((Void) -> IndexPath?)?
    
    func calculateTextViewHeight(_ textView: UITextView) -> CGFloat{
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = textView.frame
        
        let height : CGFloat = newSize.height > self.designatedHeight ? newSize.height : self.designatedHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
    
}

extension TextViewFormCell : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = calculateTextViewHeight(textView)
        
        if height > self.designatedHeight, let indexPath = getIndexPath?() {
            
            print("Osmaaaaaaan")
            self.delegate?.updateCellHeight(height: height,indexPath: indexPath)
            
            
        }
    }
}
