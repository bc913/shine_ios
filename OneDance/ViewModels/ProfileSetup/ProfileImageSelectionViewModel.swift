//
//  ProfileImageSelectionViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/21/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class ProfileImageSelectionViewModel: ProfileImageSelectionViewModelType {
    
    weak var coordinatorDelegate: ProfileImageSelectionVMCoordinatorDelegate?
    
    
    var imageName: String = ""
    
    func submit() {
        coordinatorDelegate?.userDidFinishImageSelection(viewModel: self)
    }
    
    func skip() {
        coordinatorDelegate?.userDidSkipImageSelection(viewModel: self)
    }
    
}
