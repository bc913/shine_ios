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
    
    @IBOutlet weak var skipAuthButton: UIButton!
    @IBOutlet weak var signUpWithFacebookButton: UIButton!
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appLogoLabel: UILabel!
    
    @IBAction func signUpEmailAuthButtonTapped(_ sender: Any) {
        viewModel?.presentEmailSignupScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.configureAllButtons()
        self.configureNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Configure view elements
    private func configureFacebookSignupButton(){
        self.signUpWithFacebookButton.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        self.signUpWithFacebookButton.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.signUpWithFacebookButton.setTitleColor(UIColor.white, for: .normal)
        self.signUpWithFacebookButton.setTitle(self.viewModel?.facebookAuthLabel, for: .normal)
        
        self.signUpWithFacebookButton.layer.cornerRadius = 25
        self.signUpWithFacebookButton.layer.borderWidth = 1
        self.signUpWithFacebookButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    private func configureEmailSignupButton(){
        
        self.signUpWithEmailButton.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.signUpWithEmailButton.setTitleColor(UIColor.white, for: .normal)
        self.signUpWithEmailButton.setTitle(self.viewModel?.emailAuthLabel, for: .normal)
        
        self.signUpWithEmailButton.layer.cornerRadius = 25
        self.signUpWithEmailButton.layer.borderWidth = 1
        self.signUpWithEmailButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func configureLoginButton(){
        
        self.loginButton.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.setTitle(self.viewModel?.loginLabel, for: .normal)
        
        self.loginButton.layer.cornerRadius = 25
        self.loginButton.layer.borderWidth = 1
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func configureAllButtons(){
        self.skipAuthButton.setTitle("Skip", for: .normal)
        
        self.appLogoLabel.text = "Shine"
        self.appLogoLabel.textAlignment = NSTextAlignment.center
        self.appLogoLabel.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 9))
        self.appLogoLabel.font = UIFont(name: "Zapfino", size: 46)
        self.appLogoLabel.textColor = UIColor.white
        
        configureFacebookSignupButton()
        configureEmailSignupButton()
        configureLoginButton()
    }
    
    private func configureNavigationBar(){
        // Kendisinden sonra stack a push edilen view controllerin navigation bar back buttonu nu kontrol eder
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    
    }

}
