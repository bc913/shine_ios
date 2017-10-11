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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel?.presentLoginScreen()
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
    private func configureAllButtons(){
        self.skipAuthButton.setTitle("Skip", for: .normal)
        
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
    
    
    }

}
