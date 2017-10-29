//
//  UITextField+Configure.swift
//  OneDance
//
//  Created by Burak Can on 10/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    func configure(placeholder: String){
        self.backgroundColor = UIColor.clear
        self.borderStyle = UITextBorderStyle.none
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        // Replace NSForegroundColorAttributeName with NSAttributedStringKey.foregroundColor for IOS 11
        
       
        // Apply bottom border
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        // Text color
        self.textColor = UIColor.white
        
        
    }
}
