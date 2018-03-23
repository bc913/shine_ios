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
    func mainAuthCoordinatorDidSelectSkip(authenticationCoordinator: MainAuthenticationCoordinator)
}

//===============================================================================================
//MARK: Main Auth Screen
//===============================================================================================

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
        
        let containerViewController = UINavigationController();
        window.rootViewController = containerViewController
        let authCoordinator = AuthenticationContainerCoordinator(containerNavController: containerViewController)
        authCoordinator.delegate = self
        childCoordinators["AUTH_CONTAINER"] = authCoordinator
        authCoordinator.start()
    }
    
}

extension MainAuthenticationCoordinator : AuthContainerDelegate {
    func onAuthCompleted() {
        childCoordinators["AUTH_CONTAINER"] = nil
        self.delegate?.mainAuthCoordinatorDidFinish(authenticationCoordinator: self)
    }
}

//===============================================================================================
//MARK: Authentication Container
//===============================================================================================

protocol AuthChildCoordinatorDelegate : class {
    
    func childCoordinatorDidRequestGoBack(sender: AuthBaseChildCoordinator)
    func childCoordinatorDidRequestLogin(sender: AuthBaseChildCoordinator)
    func childCoordinatorDidRequestEmailSignup(sender: AuthBaseChildCoordinator)
    func childCoordinatorDidRequestSkip(sender: AuthBaseChildCoordinator)
    
    func childCoordinatorDidCompleteEmailSignup(sender: AuthBaseChildCoordinator)
    func childCoordinatorDidCompleteLogin(sender: AuthBaseChildCoordinator)
    
}

protocol AuthContainerDelegate : class {
    func onAuthCompleted()
}

class AuthenticationContainerCoordinator {
    
    weak var delegate : AuthContainerDelegate?
    
    var containerNavigationController: UINavigationController
    
    var coordinatorStack : Stack<AuthBaseChildCoordinator> = Stack<AuthBaseChildCoordinator>()
    var childCoordinators = [String:AuthBaseChildCoordinator]()
    
    init(containerNavController: UINavigationController) {
        self.containerNavigationController = containerNavController
    }
    
    deinit {
        print("~AuthenticationContainerCoordinator()")
        self.removeAllViews()
        self.cleanCoordinatorStack()
        
    }
}

extension AuthenticationContainerCoordinator {
    
    var activeCoordinator : AuthBaseChildCoordinator? {
        return self.coordinatorStack.top
    }
}

extension AuthenticationContainerCoordinator : Coordinator {
    func start() {
        
        let rootCoordinator = AuthRootCoordinator(host: self.containerNavigationController)
        rootCoordinator.delegate = self
        //self.coordinatorStack.push(rootCoordinator)
        self.childCoordinators["ROOT"] = rootCoordinator
        rootCoordinator.start()
    }
}

extension AuthenticationContainerCoordinator : AuthChildCoordinatorDelegate {
    
    func childCoordinatorDidRequestGoBack(sender: AuthBaseChildCoordinator) {
        self.containerNavigationController.popViewController(animated: true)
        if sender is ShineLoginCoordinator {
            childCoordinators["LOGIN"] = nil
        } else if sender is ShineEmailSignUpCoordinator{
            childCoordinators["SIGNUP"] = nil
        }
        //self.coordinatorStack.pop()
    }
    
    func childCoordinatorDidRequestLogin(sender: AuthBaseChildCoordinator) {
        let loginCoordinator = ShineLoginCoordinator(host: self.containerNavigationController)
        loginCoordinator.delegate = self
        //self.coordinatorStack.push(loginCoordinator)
        childCoordinators["LOGIN"] = loginCoordinator
        loginCoordinator.start()
    }
    
    func childCoordinatorDidRequestEmailSignup(sender: AuthBaseChildCoordinator) {
        let signupCoordinator = ShineEmailSignUpCoordinator(host: self.containerNavigationController)
        signupCoordinator.delegate = self
        //self.coordinatorStack.push(signupCoordinator)
        childCoordinators["SIGNUP"] = signupCoordinator
        signupCoordinator.start()
    }
    
    func childCoordinatorDidRequestSkip(sender: AuthBaseChildCoordinator) {
        
    }
    
    func childCoordinatorDidCompleteEmailSignup(sender: AuthBaseChildCoordinator) {
        
        removeAllViews()
        cleanCoordinatorStack()
        self.childCoordinators["ROOT"] = nil
        self.delegate?.onAuthCompleted()
    }
    
    func childCoordinatorDidCompleteLogin(sender: AuthBaseChildCoordinator) {
        removeAllViews()
        cleanCoordinatorStack()
        self.childCoordinators["ROOT"] = nil
        self.delegate?.onAuthCompleted()
    }
    
    func removeAllViews(){
        self.containerNavigationController.viewControllers.removeAll()
    }
    
    func cleanCoordinatorStack(){
        let totalCoordinators = self.coordinatorStack.count
        
        if totalCoordinators < 1 {
            return
        }
        
        for _ in 1 ... totalCoordinators {
            self.coordinatorStack.pop()
        }
        
    }
}



//===============================================================================================
//MARK: Auth Base child coordinator
//===============================================================================================

protocol AuthChildViewModelCoordinatorDelegate : class {
    
    func viewModelDidSelectGoBack()
    func viewModelDidSelectLogin()
    func viewModelDidSelectEmailSignup()
    func viewModelDidSelectSkip()
    
    func viewModelDidCompleteEmailSignup()
    func viewModelDidCompleteLogin()
}

class AuthBaseChildCoordinator {
    weak var delegate : AuthChildCoordinatorDelegate?
    var hostNavigationController : UINavigationController
    
    init(host: UINavigationController) {
        self.hostNavigationController = host
    }
    
    deinit {
        
        print("~AuthBaseChildCoordinator()")
    }
    
}

extension AuthBaseChildCoordinator : AuthChildViewModelCoordinatorDelegate {
    func viewModelDidSelectGoBack() {
        self.delegate?.childCoordinatorDidRequestGoBack(sender: self)
    }
    
    func viewModelDidSelectLogin() {
        self.delegate?.childCoordinatorDidRequestLogin(sender: self)
    }
    
    func viewModelDidSelectEmailSignup() {
        self.delegate?.childCoordinatorDidRequestEmailSignup(sender: self)
    }
    
    func viewModelDidSelectSkip() {
        self.delegate?.childCoordinatorDidRequestSkip(sender: self)
    }
    
    
    
    func viewModelDidCompleteEmailSignup() {
        self.delegate?.childCoordinatorDidCompleteEmailSignup(sender: self)
    }
    
    func viewModelDidCompleteLogin() {
        self.delegate?.childCoordinatorDidCompleteLogin(sender: self)
    }
}


//===============================================================================================
//MARK: Main Auth Screen (Root)
//===============================================================================================

class AuthRootCoordinator : AuthBaseChildCoordinator{
    
}

extension AuthRootCoordinator : Coordinator {
    func start() {
        let vc = MainAuthViewController(nibName: "MainAuthViewController", bundle: nil)
        let viewModel = MainAuthViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        
        self.hostNavigationController.setViewControllers([vc], animated: false) // It is always root controller
    }
}

extension AuthRootCoordinator: MainAuthViewModelCoordinatorDelegate {
    
    func mainAuthViewModelDidSelectRegister(authType: AuthType){

        
    }
    
    
    func mainAuthViewModelDidSelectLogin(viewModel: MainAuthViewModelType){
        
    }
    
    func mainAuthViewModelDidSelectSkip(viewModel: MainAuthViewModelType){
    }
}


//===============================================================================================
//MARK: Signup Coordinator
//===============================================================================================

class ShineEmailSignUpCoordinator : AuthBaseChildCoordinator{
    
}

extension ShineEmailSignUpCoordinator : Coordinator {
    func start() {
        
        let vc = EmailSignUpViewController(nibName: "EmailSignUpViewController", bundle: nil)
        let viewModel = EmailSignUpViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        self.hostNavigationController.pushViewController(vc, animated: true)
    }
    
    
}

extension ShineEmailSignUpCoordinator : EmailSignUpViewModelCoordinatorDelegate{
    
    func emailSignUpViewModelDidCreateAccount(viewModel: EmailSignUpViewModelType) {
        //
    }

}

//===============================================================================================
//MARK: Login Coordinator
//===============================================================================================

class ShineLoginCoordinator : AuthBaseChildCoordinator {
    
}

extension ShineLoginCoordinator : Coordinator {
    func start() {
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let viewModel = LoginViewModel()
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        self.hostNavigationController.pushViewController(vc, animated: true)
    }
}

extension ShineLoginCoordinator : LoginViewModelCoordinatorDelegate{
    func userDidLogin(viewModel: LoginViewModelType) {
        
    }
}

//===============================================================================================
//MARK: Facebook Coordinator
//===============================================================================================

