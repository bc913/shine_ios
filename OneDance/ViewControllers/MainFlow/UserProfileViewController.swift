//
//  UserProfileViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/30/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var profileInfoContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileInfoSubContainer1: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!

    
    @IBOutlet weak var followContainerView: UIView!
    
    @IBOutlet weak var followerContainerView: UIView!
    @IBOutlet weak var followerCounterLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var followingContainerView: UIView!
    @IBOutlet weak var followingCounterLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    @IBOutlet weak var tagContainerView: UIView!
    
    
    @IBOutlet weak var profileTag1Container: UIView!
    @IBOutlet weak var tag1ImageView: UIImageView!
    @IBOutlet weak var tag1Label: UILabel!
    
    @IBOutlet weak var profileTag2Container: UIView!
    @IBOutlet weak var tag2ImageView: UIImageView!
    @IBOutlet weak var tag2Label: UILabel!
    
    @IBOutlet weak var profileTag3Container: UIView!
    @IBOutlet weak var tag3ImageView: UIImageView!
    @IBOutlet weak var tag3Label: UILabel!
    
    var isLoaded : Bool = false
    var viewModel : UserProfileViewModelType? {
        willSet {
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            if self.isLoaded {
                self.refreshDisplay()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.mainScrollView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.profileInfoContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        self.configureFollowContainer()
        self.configureInfoContainer()
        self.configureTagContainer()
        self.configureProfileImage()
        
        
        
        self.refreshDisplay()
        self.isLoaded = true

    }
    
    func refreshDisplay(){
        self.title = self.viewModel?.userName
        
        self.fullNameLabel.text = self.viewModel?.fullName
        self.fullNameLabel.textAlignment = .center
        self.fullNameLabel.textColor = UIColor.white
        
        self.sloganLabel.text = self.viewModel?.slogan
        self.sloganLabel.textAlignment = .center
        self.sloganLabel.textColor = UIColor.white
        
        self.linkLabel.text = self.viewModel?.bioLink
        self.linkLabel.textAlignment = .center
        self.linkLabel.textColor = UIColor.white
        
        self.followerLabel.text = "Followers"
        self.followerCounterLabel.text = self.viewModel?.followerCounter
        
        
        
        self.followingLabel.text = "Following"
        self.followingCounterLabel.text = self.viewModel?.followingCounter
        
        
        
    }
    private func configureProfileImage(){
        let profileImage : UIImage = UIImage(named: "profile")!
        self.profileImageView.image = profileImage
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.contentMode = .scaleAspectFill // veya .center
        
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureFollowContainer(){
        
        self.followContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.followerContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.followingContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
      
        self.followerLabel.textAlignment = .center
        self.followerCounterLabel.textAlignment = .center
        self.followerLabel.textColor = UIColor.white
        self.followerCounterLabel.textColor = UIColor.white
        
        let fontName = self.followerLabel.font.fontName
        self.followerLabel.font = UIFont(name: fontName, size: 12)
        self.followerCounterLabel.font = UIFont(name: fontName, size: 16)
        
        self.followingLabel.textAlignment = .center
        self.followingCounterLabel.textAlignment = .center
        self.followingLabel.textColor = UIColor.white
        self.followingCounterLabel.textColor = UIColor.white
        
        self.followingLabel.font = UIFont(name: fontName, size: 12)
        self.followingCounterLabel.font = UIFont(name: fontName, size: 16)
    }
    
    private func configureInfoContainer(){
        self.profileInfoSubContainer1.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        self.fullNameLabel.textAlignment = .center
        self.fullNameLabel.textColor = UIColor.white
        
        self.sloganLabel.textAlignment = .center
        self.sloganLabel.textColor = UIColor.white
        
        self.linkLabel.textAlignment = .center
        self.linkLabel.textColor = UIColor.white
        
        // Colors
        let fontName = self.fullNameLabel.font.fontName
        self.fullNameLabel.font = UIFont(name: fontName, size: 18)
        self.sloganLabel.font = UIFont(name: fontName, size: 12)
        self.linkLabel.font = UIFont(name: fontName, size: 12)
        
    }
    
    private func configureTagContainer(){
        
        self.tagContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.profileTag1Container.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.profileTag2Container.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.profileTag3Container.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        // Images
        let tag1Image : UIImage = UIImage(named: "dancers")!
        self.tag1ImageView.image = tag1Image
        //self.tag1ImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.tag1ImageView.clipsToBounds = true;
        self.tag1ImageView.contentMode = .scaleAspectFill // veya .center
        //self.tag1ImageView.layer.borderWidth = 3.0
        self.tag1ImageView.layer.borderColor = UIColor.white.cgColor
        
        let tag2Image : UIImage = UIImage(named: "instructor")!
        self.tag2ImageView.image = tag2Image
        //self.tag2ImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.tag2ImageView.clipsToBounds = true;
        self.tag2ImageView.contentMode = .scaleAspectFill // veya .center
        //self.tag2ImageView.layer.borderWidth = 3.0
        self.tag2ImageView.layer.borderColor = UIColor.white.cgColor
        
        let tag3Image : UIImage = UIImage(named: "dj")!
        self.tag3ImageView.image = tag3Image
        //self.tag3ImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.tag3ImageView.clipsToBounds = true;
        self.tag3ImageView.contentMode = .scaleAspectFill // veya .center
        //self.tag3ImageView.layer.borderWidth = 3.0
        self.tag3ImageView.layer.borderColor = UIColor.white.cgColor
        
        
        // Texts
        self.tag1Label.isEnabled = false
        self.tag1Label.textAlignment = .center
        self.tag1Label.textColor = UIColor.white
        
        self.tag2Label.isEnabled = false
        self.tag2Label.textAlignment = .center
        self.tag2Label.textColor = UIColor.white
        
        self.tag3Label.isEnabled = false
        self.tag3Label.textAlignment = .center
        self.tag3Label.textColor = UIColor.white
        
        // Font
        let fontName = self.tag1Label.font.fontName
        self.tag1Label.font = UIFont(name: fontName, size: 12)
        self.tag2Label.font = UIFont(name: fontName, size: 12)
        self.tag3Label.font = UIFont(name: fontName, size: 12)
        
    }
    


}

extension UserProfileViewController : UserProfileViewModelViewDelegate {
    func viewModelDidFetchUserProfile(viewModel: UserProfileViewModelType) {
        self.viewModel = viewModel
    }
}
