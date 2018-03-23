//
//  LoginViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/4/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var loginTypeControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitLoginButton: UIButton!
    
    
    var viewModel : LoginViewModelType?{
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            refreshDisplay()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log in"
        
        self.isLoaded = true
        self.configureSubmitLoginButton()
        self.configureLoginControlType()
        self.configureNavigationBar()
        
        self.emailTextField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        refreshDisplay()

    }

    override func viewDidLayoutSubviews() {
        // This method is being called after all the layout is loaded
        // The default implementation does nothing.
        self.configureAllTextFields()
        self.configureNavigationBar()
        
        // Gradient layer is problematic with auto layout
        // Use custom views
        //https://medium.com/@marcosantadev/calayer-and-auto-layout-with-swift-21b2d2b8b9d1
        let gradTopColor = UIColor(red: 15.0/255.0, green: 12.0/255.0, blue: 41.0/255.0, alpha: 0.95)
        let gradMidColor = UIColor(red: 48.0/255.0, green: 43.0/255.0, blue: 99.0/255.0, alpha: 0.95)
        let gradBottomColor = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 62.0/255.0, alpha: 0.95)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradTopColor.cgColor, gradMidColor.cgColor, gradBottomColor.cgColor]
        //gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0)
        gradientLayer.frame = self.view.bounds
        
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Actions
    func emailFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            if loginType == .email {
                viewModel?.email = text
            } else {
                viewModel?.username = text
            }
        }
    }
    
    func passwordFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.password = text
        }
    }
    
    @IBAction func submitLoginButtonTapped(_ sender: Any) {
        viewModel?.submit()
    }
    
    @IBAction func loginTypeChanged(_ sender: Any) {
        
        switch self.loginTypeControl.selectedSegmentIndex {
        case 0:
            self.emailTextField.setCustomPlaceholder(text: "Username")
            self.viewModel?.email = nil
            print("username selected")
        case 1:
            self.emailTextField.setCustomPlaceholder(text: "Email")
            self.viewModel?.username = nil
            print("email selected")
        default: break
            //
        }
        
    }
    // Private methods
    private var isLoaded: Bool = false
    
    private func refreshDisplay(){
        guard isLoaded else { return }
        
        if let viewModel = self.viewModel {
            
            if loginType == .email {
                self.emailTextField.text = viewModel.email
            } else {
                self.emailTextField.text = viewModel.username
            }
            self.passwordTextField.text = viewModel.password
            self.submitLoginButton.isEnabled = viewModel.canSubmit
        } else{
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.submitLoginButton.isEnabled = false
        }
    }
    
    private func configureSubmitLoginButton(){
        
        self.submitLoginButton.configure(title: "Login")
        
    }
    
    private func configureAllTextFields(){
        self.emailTextField.configure(placeholder: "Username")
        self.passwordTextField.configure(placeholder: "Password")
    }
    
    private func configureNavigationBar(){
        // Make navigation bar transparent
//        if let navigationBar = self.navigationController?.navigationBar {
//            navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationBar.shadowImage = UIImage()
//            navigationBar.isTranslucent = true
//        }
        
        // Customize navigation for back
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named:"back_white"), style: .plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc
    func goBack(sender: UIBarButtonItem){
        self.viewModel?.goBack()
    }
    
    private func configureLoginControlType() {
        self.loginTypeControl.setTitle("Username", forSegmentAt: 0)
        self.loginTypeControl.setTitle("Email", forSegmentAt: 1)
    }
    
    private var loginType : LoginType {
        
        if loginTypeControl.selectedSegmentIndex == 0 {
            return .username
        } else {
            return .email
        }
    }

}

fileprivate enum LoginType {
    case username
    case email
}

extension LoginViewController : LoginViewModelViewDelegate {
    
    func canSubmitStatusDidChange(_ viewModel: LoginViewModelType, status: Bool) {
        self.submitLoginButton.isEnabled = status
    }
    
    
    func notifyUser(_ viewModel: LoginViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
