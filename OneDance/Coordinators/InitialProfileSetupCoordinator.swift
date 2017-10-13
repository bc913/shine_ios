//
//  InitialProfileSetupCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 10/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol InitialProfileSetupCoordinatorDelegate : class {
    func initialProfileSetupDidFinish(initialProfileSetupCoordinator: InitialProfileSetupCoordinator)
}

class InitialProfileSetupCoordinator: Coordinator {
    
    weak var delegate: InitialProfileSetupCoordinatorDelegate?
    
    let window : UIWindow
    var childCoordinators = [String : Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let vc = DanceTypesViewController()
        let viewModel = DanceTypesViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.setViewControllers([vc], animated: true)
        }
        
        
    }
    
}


extension InitialProfileSetupCoordinator : DanceTypesViewModelCoordinatorDelegate {
    func danceTypesViewModelDidSelect(data: IDanceType, _ viewModel: DanceTypesViewModelType) {
        print("\(data.name) is selected...")
        self.delegate?.initialProfileSetupDidFinish(initialProfileSetupCoordinator: self) //Update
    }
}
