//
//  UserViewController.swift
//  OneDance
//
//  Created by Burak Can on 2/28/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    // MARK: - VIEWS
    @IBOutlet weak var mainInfoContainer: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    
    @IBOutlet weak var followerFollowingContainer: UIView!
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followerCounterLabel: UILabel!
    @IBOutlet weak var followingCounterLabel: UILabel!
    
    @IBOutlet weak var danceTypesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    fileprivate let itemsPerRow: CGFloat = 1
    
    // MARK: - PROPERTIES
    var isLoaded : Bool = false
    var viewModel : UserViewModelType?{
        didSet{
            self.viewModel?.viewDelegate = nil
        }
        willSet{
            self.viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
    }
    
    // MARK: - METHODS
    fileprivate func refreshDisplay(){
        guard self.isLoaded else {
            return
        }
        
        if let viewModel = self.viewModel {
            
            self.title = viewModel.username
            
            setLabel(self.fullNameLabel, with: viewModel.fullname, ofSize: 18)
            setLabel(self.bioLabel, with: viewModel.bio ?? "", ofSize: 14)
            setLabel(self.urlLabel, with: viewModel.websiteUrl ?? "", ofSize: 14)
            setLabel(self.followerCounterLabel, with: String(viewModel.followerCounter ?? 0), ofSize: 24)
            setLabel(self.followingCounterLabel, with: String(viewModel.followingCounter ?? 0), ofSize: 24)
            
        } else {
            
            setLabel(self.fullNameLabel, with: "", ofSize: 18)
            setLabel(self.bioLabel, with: "", ofSize: 14)
            setLabel(self.urlLabel, with: "", ofSize: 14)
            setLabel(self.followerCounterLabel, with: "", ofSize: 24)
            setLabel(self.followingCounterLabel, with: "", ofSize: 24)
        }
    }
    
    private func configureMainInfoContainer(){
        
        
        
        //self.mainInfoContainer.backgroundColor = UIColor(red: 44.0/255.0, green: 43.0/255.0, blue: 64.0/255.0, alpha: 0.95)
        
        let profileImage : UIImage = UIImage(named: "profile")!
        self.profileImageView.image = profileImage
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.contentMode = .scaleAspectFill // veya .center
        
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        
        // Labels
        self.fullNameLabel.textAlignment = .left
        self.bioLabel.textAlignment = .left
        self.urlLabel.textAlignment = .left
        
        setLabel(self.fullNameLabel, with: "", ofSize: 18)
        setLabel(self.bioLabel, with: "", ofSize: 14)
        setLabel(self.urlLabel, with: "", ofSize: 14)
        
    }
    
    private func configureFollowContainer(){
        
        self.followerFollowingContainer.backgroundColor = UIColor(red: 241.0/255.0, green: 92.0/255.0, blue: 83.0/255.0, alpha: 0.9)
        
        self.followerLabel.textAlignment = .center
        setLabel(self.followerLabel, with: "Followers", ofSize: 16)
        
        
        self.followingLabel.textAlignment = .center
        setLabel(self.followingLabel, with: "Following", ofSize: 16)
        
        // Counters
        self.followerCounterLabel.textAlignment = .center
        setLabel(self.followerCounterLabel, with: "", ofSize: 22)
        
        self.followingCounterLabel.textAlignment = .center
        setLabel(self.followingCounterLabel, with: "", ofSize: 22)
        
        
    }
    
    private func configureDanceTypesCollection(){
        
        self.flowLayout.scrollDirection = .horizontal
        self.danceTypesCollectionView.delegate = self
        self.danceTypesCollectionView.dataSource = self
        self.danceTypesCollectionView.register(BasicCollectionCell.self, forCellWithReuseIdentifier: BasicCollectionCell.identifier)
        
    }
    
    private func setLabel(_ label:UILabel, with text: String, ofSize size: CGFloat){
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: size),
                                                                                  NSForegroundColorAttributeName : UIColor.white])
        
        label.attributedText = attributedText
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.edgesForExtendedLayout = .bottom// avoid view to escape under navigation bar
        
        self.configureMainInfoContainer()
        self.configureFollowContainer()
        self.configureDanceTypesCollection()
        
        self.isLoaded = true
        self.refreshDisplay()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient layer is problematic with auto layout
        // Use custom views
        //https://medium.com/@marcosantadev/calayer-and-auto-layout-with-swift-21b2d2b8b9d1
        let gradTopColor = UIColor(red: 15.0/255.0, green: 12.0/255.0, blue: 41.0/255.0, alpha: 0.95)
        let gradMidColor = UIColor(red: 48.0/255.0, green: 43.0/255.0, blue: 99.0/255.0, alpha: 0.95)
        let gradBottomColor = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 62.0/255.0, alpha: 0.95)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradTopColor.cgColor, gradMidColor.cgColor, gradBottomColor.cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0)
        gradientLayer.frame = self.mainInfoContainer.bounds
        
        self.mainInfoContainer.layer.insertSublayer(gradientLayer, at: 0)
    }


    

}

extension UserViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionCell.identifier, for: indexPath) as! BasicCollectionCell
        
        
        return cell
    }
}

extension UserViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.top + sectionInsets.bottom + collectionView.contentInset.top + collectionView.contentInset.bottom + 4
        let availableHeight = collectionView.frame.height - paddingSpace
        let heightPerItem = availableHeight / itemsPerRow
        return CGSize(width: heightPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}


extension UserViewController : UserViewModelViewDelegate {
    func viewModelDidFetchUserProfile(viewModel: UserViewModelType) {
        self.refreshDisplay()
    }
}
