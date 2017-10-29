//
//  ProfileInfoSetupViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/24/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class ProfileInfoSetupViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var containerViewForInputs: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sloganTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    var viewModel : ProfileInfoSetupViewModelType?{
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            self.refreshDisplay()
        }
        
    }
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile Setup"
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.mainScrollView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.containerViewForInputs.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)

        // Signal slots
        self.nickNameTextField.addTarget(self, action: #selector(nickNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.sloganTextField.addTarget(self, action: #selector(sloganFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.linkTextField.addTarget(self, action: #selector(linkFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        self.isLoaded = true
        self.refreshDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        self.configureAllTextFields()
        self.configureNavigationBar()
    }
    
    // Actions
    func doneTapped() {
        print("doneTapped()")
        viewModel?.submit()
    }
    
    func nickNameFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.userName = text
        }
    }
    
    func sloganFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.slogan = text
        }
    }
    
    func linkFieldDidChange(_ textField: UITextField)
    {
        if let text = textField.text {
            viewModel?.link = text
        }
    }
    
    // Privates
    private var isLoaded : Bool = false
    
    private func refreshDisplay(){
        guard isLoaded else { return }
        
        if let viewModel = self.viewModel {
            self.nickNameTextField.text = viewModel.userName
            self.sloganTextField.text = viewModel.slogan
            self.linkTextField.text = viewModel.link
        } else{
            self.nickNameTextField.text = ""
            self.sloganTextField.text = ""
            self.linkTextField.text = ""
        }
    }
    
    private func configureAllTextFields(){
        
        self.nickNameTextField.configure(placeholder: "Nick")
        self.sloganTextField.configure(placeholder: "Your slogan")
        self.linkTextField.configure(placeholder: "Link")
    }
    
    private func configureNavigationBar(){
        // Make navigation bar transparent
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
        // Add skip
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
    }
}

extension ProfileInfoSetupViewController : ProfileInfoSetupViewModelViewDelegate {
    func notifyUserForNickNameSelection() {
        print("Notifyuserfornicknameselection()")
    }
}
