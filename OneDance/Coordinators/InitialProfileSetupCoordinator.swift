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
        let vc = DanceTypesViewController(nibName: "DanceTypesViewController", bundle: nil)
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

    }
    
    func userDidFinishDanceTypesSelection(viewModel: DanceTypesViewModelType) {
        self.showProfileImageSelector()
    }
    
    func userDidCancelDanceTypeSelection(){
        //
    }
}

extension InitialProfileSetupCoordinator : ProfileImageSelectionVMCoordinatorDelegate {
    
    func showProfileImageSelector(){
        let vc = ProfileImageSelectionViewController(nibName: "ProfileImageSelectionViewController", bundle: nil)
        let viewModel = ProfileImageSelectionViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func userDidFinishImageSelection(viewModel: ProfileImageSelectionViewModelType) {
        // notify server
        print("User did finish profile image selection")
        self.presentProfileInfoSetup()
    }
    
    func userDidSkipImageSelection(viewModel: ProfileImageSelectionViewModelType) {
        // notify server
        self.presentProfileInfoSetup()
    }
}

extension InitialProfileSetupCoordinator : ProfileInfoSetupViewModelCoordinatorDelegate {
    
    func presentProfileInfoSetup() {
        let vc = ProfileInfoSetupViewController(nibName: "ProfileInfoSetupViewController", bundle: nil)
        let viewModel = ProfileInfoSetupViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func userDidFinishProfileSetup(viewModel: ProfileInfoSetupViewModelType) {
        self.delegate?.initialProfileSetupDidFinish(initialProfileSetupCoordinator: self)
    }
}
