//
//  MainAuthenticationCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 9/17/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol MainAuthCoordinatorDelegate : class {
    func mainAuthCoordinatorDidFinish(authenticationCoordinator: MainAuthenticationCoordinator)
}

class MainAuthenticationCoordinator: Coordinator {
    // Constants
    fileprivate let FACEBOOK_KEY: String  = "Facebook"
    fileprivate let EMAIL_KEY: String  = "E-mail"
    
    weak var delegate: MainAuthCoordinatorDelegate?
    let window: UIWindow
    var childCoordinators = [String : Coordinator]()
    
    init(window: UIWindow)
    {
        self.window = window
    }
    
    func start() {
        let vc = MainAuthViewController(nibName: "MainAuthViewController", bundle: nil)
        let viewModel = MainAuthViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        let containerViewController = UINavigationController(rootViewController: vc);
        window.rootViewController = containerViewController
    }
    
}

extension MainAuthenticationCoordinator : InitialProfileSetupCoordinatorDelegate {
    func presentInitialProfileSetup(){
        let initialProfileSetupCoordinator = InitialProfileSetupCoordinator(window: self.window)
        self.childCoordinators["INITIAL_SETUP"] = initialProfileSetupCoordinator
        initialProfileSetupCoordinator.delegate = self
        initialProfileSetupCoordinator.start()
    }
    
    func initialProfileSetupDidFinish(initialProfileSetupCoordinator: InitialProfileSetupCoordinator) {
        print("MainAuthCoordinator :: initialProfileSetupDidFinish()")
    }
}

extension MainAuthenticationCoordinator : MainAuthViewModelCoordinatorDelegate {
    func mainAuthViewModelDidSelectRegister(authType: AuthType){
        print("\(authType) is selected...")
        
        // Implement child cooridnators
        
        let signUpCoordinator = SignUpCoordinator(window: self.window, type: authType)
        self.childCoordinators[authType.rawValue] = signUpCoordinator
        signUpCoordinator.delegate = self
        signUpCoordinator.start()
        
    }
    
    
    func mainAuthViewModelDidSelectLogin(viewModel: MainAuthViewModelType){
        
        let emailLoginCoordinator = EmailLoginCoordinator(window: self.window)
        self.childCoordinators["EMAIL_LOGIN"] = emailLoginCoordinator
        emailLoginCoordinator.delegate = self
        emailLoginCoordinator.start()
        
    }
    //func mainAuthViewModelDidSelectSkip(viewModel: MainAuthViewModelType)
}

extension MainAuthenticationCoordinator : SignUpCoordinatorDelegate{
    func signUpCoordinatorDidFinishSignUp(signUpCoordinator:SignUpCoordinator){
        print("signUpCoordinatorDidFinishSignUp()")
        self.childCoordinators[signUpCoordinator.authType.rawValue] = nil
        
        // Onboarding and initial setup
        self.presentInitialProfileSetup()
    }
    
}

extension MainAuthenticationCoordinator : EmailLoginCoordinatorDelegate{
    func emailLoginCoordinatorDidFinishLogin(emailLoginCoordinator: EmailLoginCoordinator) {
        print("emailLoginCoordinatorDidFinishLogin")
        self.childCoordinators["EMAIL_LOGIN"] = nil
        
        // Onboarding and initial setup
        self.presentInitialProfileSetup()
    }
}
