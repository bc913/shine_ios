//
//  BaseFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/15/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class BaseFormCell: UITableViewCell {

    override var designatedHeight: CGFloat{
        return 44.0
    }
    
    /// The block to call when the value of the text field changes.
    var valueChanged: ((Void) -> Void)?

}
