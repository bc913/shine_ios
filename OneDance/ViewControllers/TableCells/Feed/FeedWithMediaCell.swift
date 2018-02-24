//
//  FeedWithMediaCell.swift
//  OneDance
//
//  Created by Burak Can on 2/24/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class FeedWithMediaCell: FeedCell {
    
    /// Size
    var postImageHeight : CGFloat = 150.0
    
    /// Post image
    let postImageView : UIImageView = UIImageView()
    public func setPostImageView(image: UIImage){

        self.postImageView.image = image
        
    }
    
    private func setupViews(){
        
        self.clipsToBounds = true
        let views = [postImageView]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false // Activate auto layout
        }
        
        self.contentView.clipsToBounds = true
        
        // Post media
        self.postImageView.contentMode = .scaleAspectFit
        
        // Constraints
        self.setupConstraints()
        
        
    }
    
    private func setupConstraints(){
        
        // Break the constraints in the place of post image view
        self.contentView.removeConstraints([self.descriptionToLikeContainerConstraint, self.descriptionHeightConstraint])
        
        // place the image view
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.descriptionLabel,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 8.0
            ),
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.likeCommentContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: -8.0
            ),
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: self.postImageHeight
            ),
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
    }

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FeedWithMediaCell.identifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override class var identifier : String {
        return String(describing: self)
    }

}
