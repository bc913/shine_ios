//
//  UIViewController+Helper.swift
//  OneDance
//
//  Created by Burak Can on 3/13/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

extension UIViewController{
    
    var isFirstViewController : Bool {
        get{
            
            let vcList = self.navigationController?.viewControllers
            if let vcSelf = vcList?[0], vcSelf === self{
                return true
            }
            
            return false
            
        }
    }
    
}
