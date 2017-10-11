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
        self.nameTextField.addTarget(self, action: #selector(nameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.surNameTextField.addTarget(self, action: #selector(surNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.emailTextField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        refreshDisplay()
        
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
    
    func nameFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.userName = text
        }
    }
    
    func surNameFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.userSurname = text
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
            self.createAccountButton.isEnabled = viewModel.canSubmit
        } else{
            self.nameTextField.text = ""
            self.surNameTextField.text = ""
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.createAccountButton.isEnabled = false
        }
    }
    
    private func configureCreateAccountButton(){
        
        self.createAccountButton.configure(title: "Create Account")
    }
    
    
    private func configureAllTextFields(){
        
        self.nameTextField.configure(placeholder: "Name")
        self.surNameTextField.configure(placeholder: "Surname")
        self.emailTextField.configure(placeholder: "Email")
        self.passwordTextField.configure(placeholder: "Password")
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
    
    func notifyUser(_ viewModel: EmailSignUpViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        return
    }
}
