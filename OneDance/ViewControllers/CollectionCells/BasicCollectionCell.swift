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
    
    override var isSelected: Bool {
        didSet{
            self.containerView.layer.borderWidth = isSelected ? 4.0 : 0.0
        }
    }
    
    
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
        
        self.label.numberOfLines = 2
        self.label.lineBreakMode = .byWordWrapping
        
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
    
    private func setLabel(text: String){
        
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular", size: 14) ?? UIFont.boldSystemFont(ofSize: 14),
                                                                           NSForegroundColorAttributeName: UIColor.white])
        
        self.label.attributedText = attributedText
    }
    
    private func setupContainerView(){
        
    }
    
    public func configure(text: String){
        self.setLabel(text: text)
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
}
