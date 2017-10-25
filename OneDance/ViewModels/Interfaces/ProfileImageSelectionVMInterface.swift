//
//  ProfileImageSelectionVMInterface.swift
//  OneDance
//
//  Created by Burak Can on 10/21/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol ProfileImageSelectionVMCoordinatorDelegate : class {
    func userDidFinishImageSelection(viewModel: ProfileImageSelectionViewModelType)
    func userDidSkipImageSelection(viewModel : ProfileImageSelectionViewModelType)
}

protocol ProfileImageSelectionViewModelType : class {
    
    var coordinatorDelegate : ProfileImageSelectionVMCoordinatorDelegate? { get set }
    
    var imageName : String { get set }
    func submit()
    func skip()
}

