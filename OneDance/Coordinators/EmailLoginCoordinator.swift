//
//  EmailLoginCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 10/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol EmailLoginCoordinatorDelegate : class{
    func emailLoginCoordinatorDidFinishLogin(emailLoginCoordinator: EmailLoginCoordinator)
}

class EmailLoginCoordinator: Coordinator {
    weak var delegate : EmailLoginCoordinatorDelegate?
    
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let viewModel = EmailLoginViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}


extension EmailLoginCoordinator : EmailLoginViewModelCoordinatorDelegate{
    
    func userDidLogin(viewModel: EmailLoginViewModelType) {
        self.delegate?.emailLoginCoordinatorDidFinishLogin(emailLoginCoordinator: self)
    }
}
