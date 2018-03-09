//
//  CommentTableCell.swift
//  OneDance
//
//  Created by Burak Can on 3/8/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class CommentTableCell : UITableViewCell {
    
    /// Profile image
    private let profileImageView = UIImageView(image:UIImage(named: "profile"))
    public func setUserThumbnailImage(image: UIImage){
        self.profileImageView.image = image
    }
    
    private let profileImageHeight : CGFloat = 48.0
    private let profileImageWidth : CGFloat = 48.0
    
    // Username - date
    let userNameAndDateLabel = UILabel()
    let dateFormatter = DateFormatter()
    
    private func setUserNameAndDate(name: String, date: Date){
        
        let attributedText = NSMutableAttributedString(string: name.isEmpty ? "User\n" : name+"\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " - " + self.dateFormatter.string(from: date), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        self.userNameAndDateLabel.attributedText = attributedText
        
    }
    
    // Comment text
    private var commentLabel = UILabel()
    func setCommentText(text: String){
        
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        
        self.commentLabel.attributedText = attributedText
        
        
    }
    
    private func setupViews(){
        self.clipsToBounds = true
        
        let views = [profileImageView, userNameAndDateLabel, commentLabel]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Date
        self.dateFormatter.dateFormat = "MM d"
        
        // 
        self.userNameAndDateLabel.numberOfLines = 1
        self.userNameAndDateLabel.lineBreakMode = .byTruncatingTail
        
        // Comment
        self.commentLabel.numberOfLines = 0
        self.commentLabel.lineBreakMode = .byWordWrapping
        
        self.setupContraints()
    }
    
    private func setupContraints(){
        
        let imageViewheightConstraint = NSLayoutConstraint(
            item: profileImageView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: profileImageHeight
        )
        //imageViewheightConstraint.priority = 999
        
        let imageViewBottomConstraint = NSLayoutConstraint(
            item: profileImageView,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.lessThanOrEqual,
            toItem: self.contentView,
            attribute: NSLayoutAttribute.bottomMargin,
            multiplier: 1.0,
            constant: 4.0
        )
        
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.topMargin,
                multiplier: 1.0,
                constant: 0
            ),
            imageViewheightConstraint,
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageWidth
            )/*,
            imageViewBottomConstraint*/
            ])
        
        // Username - Date
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: userNameAndDateLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 8.0
            ),
            NSLayoutConstraint(
                item: userNameAndDateLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: userNameAndDateLabel,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageHeight * 0.5
            )

        ])
        
        // Username - Date
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: commentLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: userNameAndDateLabel,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: commentLabel,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.trailingMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: commentLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: userNameAndDateLabel,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 4.0
            ),
            NSLayoutConstraint(
                item: commentLabel,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottomMargin,
                multiplier: 1.0,
                constant: 4.0
            ),
            NSLayoutConstraint(
                item: commentLabel,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.greaterThanOrEqual,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageHeight * 0.5
            ),
            
        ])
        
        
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CommentTableCell.identifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    class var identifier : String {
        return String(describing: self)
    }
    
    
}
