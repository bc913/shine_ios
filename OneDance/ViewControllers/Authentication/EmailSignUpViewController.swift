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
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var containerViewForFields: UIView!
    
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.mainScrollView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.containerViewForFields.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        
        
        self.isLoaded = true
        self.configureCreateAccountButton()
        
        // Signal slots
        self.emailTextField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
    }
    
    override func viewDidLayoutSubviews() {
        // This method is being called after all the layout is loaded
        // The default implementation does nothing.
        self.configureAllTextFields()
        self.configureNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    // Actions
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
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        viewModel?.submit()
    }   
    
    
    
    // Private methods
    private var isLoaded: Bool = false
    
    private func refreshDisplay(){
        guard isLoaded else { return }
        
        if let viewModel = self.viewModel {
            self.nameTextField.text = viewModel.userName
            self.surNameTextField.text = viewModel.userSurname
            self.emailTextField.text = viewModel.email
            self.passwordTextField.text = viewModel.password
        } else{
            self.nameTextField.text = ""
            self.surNameTextField.text = ""
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    private func configureCreateAccountButton(){
        
        self.createAccountButton.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.createAccountButton.setTitleColor(UIColor.white, for: .normal)
        self.createAccountButton.setTitle("Create Account", for: .normal)
        
        self.createAccountButton.layer.cornerRadius = 25
        self.createAccountButton.layer.borderWidth = 1
        self.createAccountButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func configureTextField(textField:UITextField, placeholder: String){
        
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextBorderStyle.none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        // Replace NSForegroundColorAttributeName with NSAttributedStringKey.foregroundColor for IOS 11
        
        // Apply bottom border
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
    }
    
    private func configureAllTextFields(){
        self.configureTextField(textField: self.nameTextField, placeholder: "Name")
        self.configureTextField(textField: self.surNameTextField, placeholder: "Surname")
        self.configureTextField(textField: self.emailTextField, placeholder: "Email")
        self.configureTextField(textField: self.passwordTextField, placeholder: "Password")
    }
    
    private func configureNavigationBar(){
        // Make navigation bar transparent
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }       
        
    }

    
}

extension EmailSignUpViewController: EmailSignUpViewModelViewDelegate
{
    func canSubmitStatusDidChange(_ viewModel: EmailSignUpViewModelType, status: Bool)
    {
        self.createAccountButton.isEnabled = status
    }
    
    
//    func errorMessageDidChange(_ viewModel: EmailSignUpViewModelType, message: String)
//    {
//        errorMessageLabel.text = message
//    }
}
