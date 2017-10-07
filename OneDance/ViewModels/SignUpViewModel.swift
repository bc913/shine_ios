//
//  SignUpViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class EmailSignUpViewModel: EmailSignUpViewModelType {
    
    weak var coordinatorDelegate: EmailSignUpViewModelCoordinatorDelegate?
    weak var viewDelegate: EmailSignUpViewModelViewDelegate?
    
    var userName: String = ""
    var userSurname: String = ""
    var email: String = ""
    var password: String = ""
    
    func submit() {
        print("EmailSignUpVM :: submit()")
        self.coordinatorDelegate?.emailSignUpViewModelDidCreateAccount(viewModel: self)
    }
}
