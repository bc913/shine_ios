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
    
    var item : Feed = Feed()
}

protocol FeedableCell {
    
    func setUserThumbnailImage(image:UIImage)
}

class FeedCell: BaseFeedCell, UserNameTappableCell, LikeableView {

    
    override var item : Feed {
        didSet{
            self.setUserNameAndDate(name: item.username, date: item.date)
            // Desc
            self.setDescriptionLabel(desc: item.text)
            // Location
            self.setLocationLabel(name: item.location)
            
            // Likes - Comments counter
            self.setLikeCommentCounter(likeCounter: item.likeCounter, commentCounter: item.commentCounter)
            
            // Like state
            self.isLikedPost = false
            
        }
    }
    
    var isLikedPost = false {
        didSet{
            if oldValue == false && isLikedPost {
                self.likeImageView.image = UIImage(named: "like_red")
                self.setLikeCommentCounter(likeCounter: self.item.likeCounter + 1, commentCounter: self.item.commentCounter)
                self.likeHandler?()
                return
            }
            
            if oldValue == true && !isLikedPost {
                self.likeImageView.image = UIImage(named: "like_empty")
                self.setLikeCommentCounter(likeCounter: self.item.likeCounter - 1, commentCounter: self.item.commentCounter)
                self.reomoveLikeHandler?()
                return
            }
        }
    }
    
    // Dimensions
    private let upperContainerHeight : CGFloat = 66.0
    private let cellTopMargin : CGFloat = 4.0
    private let likeCommentContainerHeight : CGFloat = 32.0
    
    var didSetupConstraints = false
    
    private let profileImageHeight : CGFloat = 44.0
    private let profileImageWidth : CGFloat = 44.0
    
    // Handlers    
    /// The block to handle comment action
    var commentHandler: ((Void) -> Void)?
    
    /// The block to handle like list action
    var likeListHandler:((Void) -> Void)?
    
    /// the block to handle user or organization name tapped
    var ownerHandler: ((Void) -> (Void))?
    
    /// Like action handlers
    var likeHandler: ((Void) -> (Void))?
    var reomoveLikeHandler: ((Void) -> (Void))?
    
    
    //MARK: SUBVIEWS
    
    /// Upper Container
    let upperContainer = UIView()
    
    private let profileImageView = UIImageView(image:UIImage(named: "profile"))
    public func setUserThumbnailImage(image: UIImage){
        self.profileImageView.image = image
    }
    
    
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
    
    @objc
    func usernameTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil{
            self.ownerHandler?()
        }
    }
    
    /// Location
    let locationLabel = UILabel()
    private func setLocationLabel(name: String = ""){
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        self.locationLabel.attributedText = attributedText
    }
    
    // likeCommentContainer
    let likeCommentContainer = UIView()
    
    // Like
    let likeImageView = UIImageView(image: UIImage(named: "like_empty"))
    let likeCounterLabel = UILabel()
    
    @objc
    func likeTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view as? UIImageView) != nil{
            
            self.isLikedPost = !self.isLikedPost
            
        }

        
    }
    
    @objc
    private func likeCounterTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil{
            
            print("likeCounter = \(self.item.likeCounter)")
            if self.item.likeCounter > 0 {
                self.likeListHandler?()
            }
            
        }
        
    }
    
    // Comment
    let commentImageView = UIImageView(image: UIImage(named: "comment"))
    let commentCounterLabel = UILabel()
    
    private func setLikeCommentCounter(likeCounter: Int, commentCounter: Int){
        
        //TODO: Apply different formatting for different ranges
        
        let likeCounterAttrText = NSAttributedString(string: String(likeCounter), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])
        
        
        let commentCounterAttrText = NSAttributedString(string: String(commentCounter), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])
        
        self.likeCounterLabel.attributedText = likeCounterAttrText
        self.commentCounterLabel.attributedText = commentCounterAttrText
        
    }
    
    @objc
    private func commentTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil{
            print("CommentCounter = \(self.item.commentCounter)")
                self.commentHandler?()            
        }
        
    }
    
    
    
    /// Description
    let descriptionLabel = UILabel()
    public func setDescriptionLabel(desc: String){
        let attributedText = NSMutableAttributedString(string: desc, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        self.descriptionLabel.attributedText = attributedText
        
    }
    
    /// Constraints
    var upperToDescriptionConstraint = NSLayoutConstraint()
    var descriptionToLikeContainerConstraint = NSLayoutConstraint()
    var descriptionHeightConstraint = NSLayoutConstraint()
    
    
    private func setupViews(){
        
        self.clipsToBounds = true
        
        let views = [
            profileImageView, userNameAndDateLabel, locationLabel, upperContainer,
            likeCommentContainer, likeImageView, likeCounterLabel, commentImageView, commentCounterLabel,
            descriptionLabel
        ]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false // Activate auto layout
        }
        
        // Date
        self.dateFormatter.dateFormat = "MMMM d, yyyy"
        
        // Thumbnail
        self.profileImageView.contentMode = .scaleAspectFit
        
        // Username
        self.userNameAndDateLabel.numberOfLines = 2
        self.setUserNameAndDate(name: "", date: Date())
        
        // Location
        self.setLocationLabel()
        
        // Description
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        //self.setDescriptionLabel(desc: "lmalnamsndasd,asdmnalsjdkbabskdbasmdnasdfhsdfjshdfjsdjfhsjasdasdasdasdasdasdasdadasdadsasdadfhvsjhdfvsdfsdfsdsd")
        
        
        // Comment
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTapped(tapGestureRecognizer:)))
        self.commentImageView.isUserInteractionEnabled = true
        self.commentImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.commentCounterLabel.numberOfLines = 1
        
        // Like
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(likeCounterTapped(tapGestureRecognizer:)))
        self.likeCounterLabel.isUserInteractionEnabled = true
        self.likeCounterLabel.addGestureRecognizer(tapGestureRecognizer2)
        
        self.likeCounterLabel.numberOfLines = 1
        
        let likeImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped(tapGestureRecognizer:)))
        self.likeImageView.isUserInteractionEnabled = true
        self.likeImageView.addGestureRecognizer(likeImageTapGesture)
        
        self.setLikeCommentCounter(likeCounter: 0, commentCounter: 0)
        
        // Owner
        let ownerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(usernameTapped(tapGestureRecognizer:)))
        self.userNameAndDateLabel.isUserInteractionEnabled = true
        self.userNameAndDateLabel.addGestureRecognizer(ownerTapRecognizer)
        
        
        // Constraints
        self.upperContainer.addSubview(self.profileImageView)
        self.upperContainer.addSubview(userNameAndDateLabel)
        self.upperContainer.addSubview(locationLabel)
        
        self.likeCommentContainer.addSubview(likeImageView)
        self.likeCommentContainer.addSubview(commentImageView)
        self.likeCommentContainer.addSubview(likeCounterLabel)
        self.likeCommentContainer.addSubview(commentCounterLabel)
        
        self.setupContraints()
        self.didSetupConstraints = true
    }
    
    override func updateConstraints() {
        
        if !self.didSetupConstraints {
            self.setupContraints()
            self.didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func setupContraints(){
        
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
                constant: 0.0 //self.cellTopMargin
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
        
        upperToDescriptionConstraint = NSLayoutConstraint(
            item: descriptionLabel,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: upperContainer,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: 8.0
        )
        
        descriptionToLikeContainerConstraint = NSLayoutConstraint(
            item: descriptionLabel,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: likeCommentContainer,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: -8.0
        )
        
        self.descriptionHeightConstraint = NSLayoutConstraint(
            item: descriptionLabel,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.greaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: 48.0
        )
        
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
            upperToDescriptionConstraint,
            descriptionToLikeContainerConstraint,
            NSLayoutConstraint(
                item: descriptionLabel,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            descriptionHeightConstraint
        ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: likeCommentContainer,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
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
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0.0
            )
        ])
        
        // Like
        self.likeCommentContainer.addConstraints([
            NSLayoutConstraint(
                item: likeCounterLabel,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: likeCounterLabel,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: likeCounterLabel,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 24.0
            )
        ])
        
        self.likeCommentContainer.addConstraints([
            NSLayoutConstraint(
                item: likeImageView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCounterLabel,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 4.0
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
        
        // Comment
        
        self.likeCommentContainer.addConstraints([
            NSLayoutConstraint(
                item: commentCounterLabel,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeImageView,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 8.0
            ),
            NSLayoutConstraint(
                item: commentCounterLabel,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: likeCommentContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: commentCounterLabel,
                attribute: NSLayoutAttribute.height,
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
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: commentCounterLabel,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 4.0
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
    
    class var identifier : String {
        return String(describing: self)
    }

}

extension FeedCell : FeedableCell{}
