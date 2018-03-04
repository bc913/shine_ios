//
//  MainAuthViewController.swift
//  OneDance
//
//  Created by Burak Can on 9/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class MainAuthViewController: UIViewController {

    var viewModel : MainAuthViewModelType?
    
    @IBOutlet weak var signUpWithFacebookButton: UIButton!
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appLogoLabel: UILabel!
    
    @IBAction func signUpEmailAuthButtonTapped(_ sender: Any) {
        viewModel?.presentEmailSignupScreen()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel?.presentLoginScreen()
    }
    
    func skipTapped() {
        viewModel?.skipAuth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.configureAllButtons()
        self.configureNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        // Make navigation bar transparent
//        if let navigationBar = self.navigationController?.navigationBar {
//            navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationBar.shadowImage = UIImage()
//            navigationBar.isTranslucent = true
//        }
        
        // Gradient layer is problematic with auto layout
        // Use custom views
        //https://medium.com/@marcosantadev/calayer-and-auto-layout-with-swift-21b2d2b8b9d1
        let gradTopColor = UIColor(red: 15.0/255.0, green: 12.0/255.0, blue: 41.0/255.0, alpha: 0.95)
        let gradMidColor = UIColor(red: 48.0/255.0, green: 43.0/255.0, blue: 99.0/255.0, alpha: 0.95)
        let gradBottomColor = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 62.0/255.0, alpha: 0.95)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradTopColor.cgColor, gradMidColor.cgColor, gradBottomColor.cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0)
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
  
    // Configure view elements
    private func configureAllButtons(){
        
        self.appLogoLabel.text = "Shine"
        self.appLogoLabel.textAlignment = NSTextAlignment.center
        self.appLogoLabel.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 9))
        self.appLogoLabel.font = UIFont(name: "Zapfino", size: 46)
        self.appLogoLabel.textColor = UIColor.white
        
        self.signUpWithFacebookButton.configure(title: self.viewModel?.facebookAuthLabel, backgroundColor: UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0))
        self.signUpWithEmailButton.configure(title: self.viewModel?.emailAuthLabel)
        self.loginButton.configure(title: self.viewModel?.loginLabel)
        
        
    }
    
    private func configureNavigationBar(){
        // Kendisinden sonra stack a push edilen view controllerin navigation bar back buttonu nu kontrol eder
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Add skip
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
    
    
    }

    

}
