//
//  BasicView.swift
//  OneDance
//
//  Created by Burak Can on 3/2/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

@IBDesignable
class BasicView: UIView {
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView(){
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        let gradTopColor = UIColor(red: 15.0/255.0, green: 12.0/255.0, blue: 41.0/255.0, alpha: 0.95)
        let gradMidColor = UIColor(red: 48.0/255.0, green: 43.0/255.0, blue: 99.0/255.0, alpha: 0.95)
        let gradBottomColor = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 62.0/255.0, alpha: 0.95)
        
        
        gradientLayer.colors = [gradTopColor.cgColor, gradMidColor.cgColor, gradBottomColor.cgColor]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    static var identifier : String {
        return String(describing: self)
    }
    
}
