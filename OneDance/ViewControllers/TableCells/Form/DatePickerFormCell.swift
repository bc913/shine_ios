//
//  DatePickerFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/18/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

protocol DatePickerDelegate : class {
    func updateDate(selectedDate: Date)
}

class DatePickerFormCell: BaseFormCell {
    
    weak var parentCell : DatePickerDelegate?
    
    @IBAction func dateValueUpdated(_ sender: Any) {
        
        if let picker = sender as? UIDatePicker{
            parentCell?.updateDate(selectedDate: picker.date)
        }
        
    }   
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    override var designatedHeight: CGFloat {
        return 216.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
