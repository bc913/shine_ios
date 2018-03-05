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
        
        self.layer.borderColor = UIColor(red: 241.0/255.0, green: 92.0/255.0, blue: 83.0/255.0, alpha: 0.9).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    class var identifier : String {
        return String(describing: self)
    }
    
}

@IBDesignable
class BasicViewWithText: BasicView{
    
    private var label = UILabel()
    
    convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        setLabel(text: text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override class var identifier : String{
        return String(describing: self)
    }
    
    private func setLabel(text: String){
        
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular", size: 14) ?? UIFont.boldSystemFont(ofSize: 14),
                                                                           NSForegroundColorAttributeName: UIColor.white])
        
        self.label.attributedText = attributedText
    }
    
    private func setupView(){
        
        // Constraints
        self.addConstraints([
            NSLayoutConstraint(
                item: self.label,
                attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.centerX,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.label,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
    }
}
