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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitLoginButton: UIButton!
    
    
    var viewModel : EmailLoginViewModelType?{
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
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.mainScrollView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.textFieldContainerView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        self.isLoaded = true
        self.configureSubmitLoginButton()
        
        self.emailTextField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        refreshDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        // This method is being called after all the layout is loaded
        // The default implementation does nothing.
        self.configureAllTextFields()
        self.configureNavigationBar()
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
    
    @IBAction func submitLoginButtonTapped(_ sender: Any) {
        viewModel?.submit()
    }
    
    // Private methods
    private var isLoaded: Bool = false
    
    private func refreshDisplay(){
        guard isLoaded else { return }
        
        if let viewModel = self.viewModel {
            self.emailTextField.text = viewModel.email
            self.passwordTextField.text = viewModel.password
            self.submitLoginButton.isEnabled = viewModel.canSubmit
        } else{
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.submitLoginButton.isEnabled = false
        }
    }
    
    private func configureSubmitLoginButton(){
        
        self.submitLoginButton.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.submitLoginButton.setTitleColor(UIColor.white, for: .normal)
        self.submitLoginButton.setTitle("Login", for: .normal)
        
        self.submitLoginButton.layer.cornerRadius = 25
        self.submitLoginButton.layer.borderWidth = 1
        self.submitLoginButton.layer.borderColor = UIColor.white.cgColor
        
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
        
        // Text color
        textField.textColor = UIColor.white
        
    }
    
    private func configureAllTextFields(){
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

extension LoginViewController : EmailLoginViewModelViewDelegate {
    
    func canSubmitStatusDidChange(_ viewModel: EmailLoginViewModelType, status: Bool) {
        self.submitLoginButton.isEnabled = status
    }
    
    
    func notifyUser(_ viewModel: EmailLoginViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        return
    }
}
