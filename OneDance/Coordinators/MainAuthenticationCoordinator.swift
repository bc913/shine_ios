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
//MARK: Auth Base child coordinator
//===============================================================================================

protocol AuthChildViewModelCoordinatorDelegate : class {
    
    func viewModelDidSelectGoBack()
    func viewModelDidSelectLogin()
    func viewModelDidSelectEmailSignup()
    func viewModelDidSelectSkip()
    
    func viewModelDidCompleteEmailSignup()
}

class AuthBaseChildCoordinator {
    weak var delegate : AuthChildCoordinatorDelegate?
    var hostNavigationController : UINavigationController
    
    init(host: UINavigationController) {
        self.hostNavigationController = host
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
    
}

protocol AuthContainerDelegate : class {
    func onAuthCompleted()
}

class AuthenticationContainerCoordinator {
    
    weak var delegate : AuthContainerDelegate?
    
    var containerNavigationController: UINavigationController
    
    var coordinatorStack : Stack<AuthBaseChildCoordinator> = Stack<AuthBaseChildCoordinator>()
    
    init(containerNavController: UINavigationController) {
        self.containerNavigationController = containerNavController
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
        self.coordinatorStack.push(rootCoordinator)
        rootCoordinator.start()
    }
}

extension AuthenticationContainerCoordinator : AuthChildCoordinatorDelegate {
    
    func childCoordinatorDidRequestGoBack(sender: AuthBaseChildCoordinator) {
        self.containerNavigationController.popViewController(animated: true)
        self.coordinatorStack.pop()
    }
    
    func childCoordinatorDidRequestLogin(sender: AuthBaseChildCoordinator) {
        
    }
    
    func childCoordinatorDidRequestEmailSignup(sender: AuthBaseChildCoordinator) {
        let signupCoordinator = ShineEmailSignUpCoordinator(host: self.containerNavigationController)
        signupCoordinator.delegate = self
        self.coordinatorStack.push(signupCoordinator)
        signupCoordinator.start()
    }
    
    func childCoordinatorDidRequestSkip(sender: AuthBaseChildCoordinator) {
        
    }
    
    func childCoordinatorDidCompleteEmailSignup(sender: AuthBaseChildCoordinator) {
        
        removeAllViews()
        cleanCoordinatorStack()
        
        self.delegate?.onAuthCompleted()
    }
    
    private func removeAllViews(){
        self.containerNavigationController.viewControllers.removeAll()
    }
    
    private func cleanCoordinatorStack(){
        let totalCoordinators = self.coordinatorStack.count
        
        for _ in 1 ... totalCoordinators {
            self.coordinatorStack.pop()
        }

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
    
    func mainAuthViewModelDidSelectSkip(viewModel: MainAuthViewModelType){
        self.delegate?.mainAuthCoordinatorDidSelectSkip(authenticationCoordinator: self)
    }
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
        self.delegate?.mainAuthCoordinatorDidFinish(authenticationCoordinator: self)
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
        self.delegate?.mainAuthCoordinatorDidFinish(authenticationCoordinator: self)
    }
}
