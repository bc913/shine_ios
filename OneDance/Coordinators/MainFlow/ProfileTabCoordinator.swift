//
//  ProfileTabCoordinator.swift
//  OneDance
//
//  Created by Burak Can on 3/3/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit


class ProfileTabCoordinator: BaseContainerCoordinator, Coordinator {
    
    func start() {
        self.showMyProfile()
    }
    
    func showMyProfile(){
        
        let userProfileCoordinator = UserProfileCoordinator(host: self.containerNavigationController, id: PersistanceManager.User.userId!)
        userProfileCoordinator.delegate = self
        self.coordinatorStack.push(userProfileCoordinator)
        userProfileCoordinator.start()
        
    }
    
}

//===============================================================================================
//MARK: UserProfileCoordinator
//===============================================================================================

class UserProfileCoordinator : BaseChildCoordinator {
    
    var mode : ShineMode
    
    init(host: UINavigationController, id: String, mode: ShineMode = .viewOnly) {
        self.mode = mode
        //self.viewModel = EventViewModel(mode: self.mode, id: id)
        super.init(host:host, id: id)
    }
    
    override convenience init(host: UINavigationController, id: String) {
        self.init(host:host, id: id, mode: .viewOnly)
    }
}

extension UserProfileCoordinator : Coordinator {
    
    func start() {
        if mode == .viewOnly{
            startViewOnly()
        } else if self.mode == .edit {
            startEdit()
        }
        
    }
    
    fileprivate func startViewOnly(){
        let vc = UserViewController(nibName: "UserViewController", bundle: nil)
        let viewModel = UserViewModel(mode: .viewOnly, id: self.id)
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        self.hostNavigationController.setViewControllers([vc], animated: false) // It is always root controller
    }
    
    fileprivate func startEdit(){
        let vc = EditUserProfileViewController()
        let viewModel = UserViewModel(mode: .edit, id: self.id)
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.hostNavigationController.topViewController?.present(navigationController, animated:true)
    }
}

extension UserProfileCoordinator : UserViewModelCoordinatorDelegate{
    
}
