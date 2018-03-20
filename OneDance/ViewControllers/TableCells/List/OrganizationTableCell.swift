//
//  OrganizationTableCell.swift
//  OneDance
//
//  Created by Burak Can on 3/19/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class OrganizationTableCell: UITableViewCell {

    weak var ownerDelegate : CellOwnerDelegate?
    
    /// Profile image
    private let profileImageView = UIImageView(image:UIImage(named: "profile"))
    public func setUserThumbnailImage(image: UIImage){
        self.profileImageView.image = image
    }
    
    private let profileImageHeight : CGFloat = 48.0
    private let profileImageWidth : CGFloat = 48.0
    
    /// Username label
    private let fullNameAndFollowerLabel : UILabel = UILabel()
    
    public func setFullNameAndFollowers(fullname: String, followers: Int){
        
        let attributedText = NSMutableAttributedString(string: fullname.isEmpty ? "Organization\n" : fullname+"\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\(String(followers)) followers", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        self.fullNameAndFollowerLabel.attributedText = attributedText
        
    }
    
    @objc
    func ownerTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil{
            self.ownerDelegate?.ownerNameTapped(self)
        }
    }
    
    /// Dance types label
    private let danceTypesLabel : UILabel = UILabel()
    
    public func setDanceTypesLabel(dances: [DanceType]){
        
        var typesString : String = ""
        var index : Int = 0
        
        for dance in dances {
            index += 1
            if index < 3 {
                typesString += "\(dance.name),"
            }
        }
        
        typesString.remove(at: typesString.index(before: typesString.endIndex))
        
        if dances.count > 3 {
            typesString += "..."
        }
        
    }
    
    private func setupViews(){
        self.clipsToBounds = true
        let views = [profileImageView, fullNameAndFollowerLabel, danceTypesLabel]
        
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Thumbnail
        self.profileImageView.contentMode = .scaleAspectFit
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ownerTapped(tapGestureRecognizer:)))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(imageTapRecognizer)
        
        
        // Username
        self.fullNameAndFollowerLabel.numberOfLines = 2
        let ownerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ownerTapped(tapGestureRecognizer:)))
        self.fullNameAndFollowerLabel.isUserInteractionEnabled = true
        self.fullNameAndFollowerLabel.addGestureRecognizer(ownerTapRecognizer)
        
        
        
        self.setupConstraints()
    }
    
    private func setupConstraints(){
        
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
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
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
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: fullNameAndFollowerLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 8.0
            ),
            NSLayoutConstraint(
                item: fullNameAndFollowerLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: profileImageView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            )
        ])
        
        // DAnce types
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: danceTypesLabel,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.trailingMargin,
                multiplier: 1.0,
                constant: -8.0
            ),
            NSLayoutConstraint(
                item: danceTypesLabel,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottomMargin,
                multiplier: 1.0,
                constant: -8.0
            )
        ])
        
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: OrganizationTableCell.identifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    class var identifier : String {
        return String(describing: self)
    }
    
    override var designatedHeight: CGFloat{
        return 64.0
    }
    

}
