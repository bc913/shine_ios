//
//  UIButton+Configure.swift
//  OneDance
//
//  Created by Burak Can on 10/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func configure(title: String?, backgroundColor:UIColor? = nil){
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        self.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitle(title, for: .normal)
        
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
    }
}
