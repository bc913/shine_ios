//
//  SignUpCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpCoordinatorDelegate : class {
    func signUpCoordinatorDidFinishSignUp(signUpCoordinator:SignUpCoordinator)
}

class SignUpCoordinator : Coordinator{
    
    weak var delegate : SignUpCoordinatorDelegate?
    
    let window: UIWindow
    var childCoordinators = [String : Coordinator]() // Empty
    let authType: AuthType
    
    
    
    init(window: UIWindow, type: AuthType) {
        self.window = window
        self.authType = type
    }
    
    func start() {
        if self.authType == .Email {
            let vc = EmailSignUpViewController(nibName: "EmailSignUpViewController", bundle: nil)
            let viewModel = EmailSignUpViewModel()
            viewModel.coordinatorDelegate = self
            vc.viewModel = viewModel
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.pushViewController(vc, animated: true)
            }
            //window.rootViewController = vc
            
        }
    }
    
    
}

extension SignUpCoordinator : EmailSignUpViewModelCoordinatorDelegate {
    func emailSignUpViewModelDidCreateAccount(viewModel: EmailSignUpViewModelType) {
        self.delegate?.signUpCoordinatorDidFinishSignUp(signUpCoordinator: self)
    }
    
}
