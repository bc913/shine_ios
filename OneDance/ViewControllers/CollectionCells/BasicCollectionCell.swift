//
//  BasicCollectionCell.swift
//  OneDance
//
//  Created by Burak Can on 3/1/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class BasicCollectionCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private var containerView : BasicView
    
    private var label = UILabel()
    
    
    override init(frame: CGRect) {
        containerView = BasicView(frame: frame)
        super.init(frame: frame)
        
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        containerView = BasicView(coder: aDecoder)!
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    
    private func setupViews(){
        
        self.clipsToBounds = true
        
        let views = [containerView as UIView, label]
        for view in views{
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        // Constraints
        self.setupConstraints()
        
    }
    
    private func setupConstraints(){
        
        self.containerView.addSubview(self.label)
        self.containerView.addConstraints([
            NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.containerView,
                attribute: NSLayoutAttribute.centerX,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.containerView,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: containerView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
    }
    
    private func setupLabel(_ text: String){
        
    }
    
    private func setupContainerView(){
        
    }
    
    public func configure(text: String){
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
}
