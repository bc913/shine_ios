//
//  EmailSignUpViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class EmailSignUpViewController: UIViewController {
    
    var viewModel:EmailSignUpViewModelType?{
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            refreshDisplay()
        }
    }
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var containerViewForFields: UIView!
    
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign up"
        
        self.isLoaded = true
        self.configureCreateAccountButton()
        
        // Signal slots
        
        self.nameTextField.addTarget(self, action: #selector(nameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.userNameTextField.addTarget(self, action: #selector(userNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.emailTextField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        refreshDisplay()
        
    }
    
    override func viewDidLayoutSubviews() {
        
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
        
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        // This method is being called after all the layout is loaded
        // The default implementation does nothing.
        self.configureAllTextFields()
        
        
        
    }
    
    // Actions
    func userNameFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.userName = text
        }
    }
    
    func emailFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.email = text
        }
    }
    
    func passwordFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.password = text
        }
    }
    
    func nameFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.name = text
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        viewModel?.submit()
    }   
    
    
    
    // Private methods
    private var isLoaded: Bool = false
    
    private func refreshDisplay(){
        guard isLoaded else { return }
        
        if let viewModel = self.viewModel {
            self.userNameTextField.text = viewModel.userName
            self.nameTextField.text = viewModel.name
            self.emailTextField.text = viewModel.email
            self.passwordTextField.text = viewModel.password
            self.createAccountButton.isEnabled = viewModel.canSubmit
            self.createAccountButton.isHidden = !viewModel.canSubmit
        } else{
            self.userNameTextField.text = ""
            self.nameTextField.text = ""
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.createAccountButton.isEnabled = false
            self.createAccountButton.isHidden = true
        }
    }
    
    private func configureCreateAccountButton(){
        
        self.createAccountButton.configure(title: "Create Account")
    }
    
    
    private func configureAllTextFields(){
        self.nameTextField.configure(placeholder: "Name")
        self.userNameTextField.configure(placeholder: "Username")
        self.emailTextField.configure(placeholder: "Email")
        self.passwordTextField.configure(placeholder: "Password")
    }
    
    private func configureNavigationBar(){
        // Make navigation bar transparent
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        }       
        
    }
    

    
}

extension EmailSignUpViewController: EmailSignUpViewModelViewDelegate
{
    func canSubmitStatusDidChange(_ viewModel: EmailSignUpViewModelType, status: Bool)
    {
        self.createAccountButton.isEnabled = status
        self.createAccountButton.isHidden = !status
    }
    
    func notifyUser(_ viewModel: EmailSignUpViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        return
    }
}
