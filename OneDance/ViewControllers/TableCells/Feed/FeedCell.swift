//
//  FeedCell.swift
//  OneDance
//
//  Created by Burak Can on 2/17/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit


class BaseFeedCell: UITableViewCell {
    
    override var designatedHeight: CGFloat {
        return 276.0
    }
    
}

class FeedCell: BaseFeedCell {

    
    var item : Feed = Feed() {
        didSet{
            self.setUserNameAndDate(name: item.username, date: item.date)
            // Desc
            self.setDescriptionLabel(desc: item.text)
            
        }
    }
    
    // Dimensions
    let postImageHeight : CGFloat = 150.0
    let upperContainerHeight : CGFloat = 66.0
    let cellTopMargin : CGFloat = 4.0
    let likeCommentContainerHeight : CGFloat = 32.0
    
    
    let profileImageHeight : CGFloat = 44.0
    let profileImageWidth : CGFloat = 44.0
    
    
    
    //MARK: SUBVIEWS
    let profileImageView = UIImageView(image:UIImage(named: "profile"))
    
    let userNameAndDateLabel = UILabel()
    let dateFormatter = DateFormatter()
    
    private func setUserNameAndDate(name: String, date: Date){
        
        let attributedText = NSMutableAttributedString(string: name.isEmpty ? "User\n" : name+"\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: self.dateFormatter.string(from: date), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        self.userNameAndDateLabel.attributedText = attributedText
        
    }
    
    /// Location
    let locationLabel = UILabel()
    private func setLocationLabel(){
        
        let attributedText = NSMutableAttributedString(string: "Location", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        self.locationLabel.attributedText = attributedText
    }
    
    /// Upper Container
    let upperContainer = UIView()
    
    /// Post image
    let postImageView = UIImageView()
    private func setPostImageView(){
        
        self.postImageView.contentMode = .scaleAspectFit
        
    }
    
    // likeCommentContainer
    let likeCommentContainer = UIView()
    let likeImageView = UIImageView(image: UIImage(named: "like"))
    let commentImageView = UIImageView(image: UIImage(named: "comment"))
    
    /// Description
    let descriptionLabel = UILabel()
    public func setDescriptionLabel(desc: String){
        let attributedText = NSMutableAttributedString(string: desc, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        self.descriptionLabel.attributedText = attributedText
        
    }
    
    
    private func setupViews(){
        
        self.clipsToBounds = true
        
        let views = [profileImageView, userNameAndDateLabel, locationLabel, upperContainer, postImageView, likeCommentContainer, likeImageView, commentImageView, descriptionLabel]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false // Activate auto layout
        }
        
        // Date
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .none
        
        // Thumbnail
        self.profileImageView.contentMode = .scaleAspectFit
        
        // Username
        self.userNameAndDateLabel.numberOfLines = 2
        self.setUserNameAndDate(name: "", date: Date())
        
        // Location
        self.setLocationLabel()
        
        // Post image
        self.setPostImageView()
        
        // Description
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        self.setDescriptionLabel(desc: "lmalnamsndasd,asdmnalsjdkbabskdbasmdnasdfhsdfjshdfjsdjfhsjdfhvsjhdfvsdfsdfsdsd")
        
        // Constraints
        self.setupContraints()
    }
    
    private func setupContraints(){
        
        self.upperContainer.addSubview(self.profileImageView)
        self.upperContainer.addSubview(userNameAndDateLabel)
        self.upperContainer.addSubview(locationLabel)
        
        // thumbnail
       
        self.upperContainer.addConstraints([
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: upperContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: upperContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageHeight
            ),
            NSLayoutConstraint(
                item: profileImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: profileImageWidth
            )
        ])
        
        // Username - Date
        self.upperContainer.addConstraints([
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
            )
        ])
        
        // Location
        self.upperContainer.addConstraints([
            NSLayoutConstraint(
                item: locationLabel,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: upperContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: locationLabel,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            )
        ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: upperContainer,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: upperContainer,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: self.cellTopMargin
            ),
            NSLayoutConstraint(
                item: upperContainer,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: self.upperContainerHeight
            ),
            NSLayoutConstraint(
                item: upperContainer,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            )
        ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: postImageView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: upperContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
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
                constant: 0
            )
        ])
        
        
        self.likeCommentContainer.addSubview(likeImageView)
        self.likeCommentContainer.addSubview(commentImageView)
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: postImageView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: self.likeCommentContainerHeight
            ),
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
        self.likeCommentContainer.addConstraints([
            NSLayoutConstraint(
                item: likeImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: likeImageView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: likeImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            ),
            NSLayoutConstraint(
                item: likeImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            )
        ])
        
        self.likeCommentContainer.addConstraints([
            NSLayoutConstraint(
                item: commentImageView,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeImageView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 16.0
            ),
            NSLayoutConstraint(
                item: commentImageView,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: commentImageView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            ),
            NSLayoutConstraint(
                item: commentImageView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            )
        ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: descriptionLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: descriptionLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: descriptionLabel,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: descriptionLabel,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            )
        ])
        
        
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FeedCell.identifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
   
    
    

}
