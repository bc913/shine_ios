//
//  LocationViewModels.swift
//  OneDance
//
//  Created by Burak Can on 3/13/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

//===============================================================================================
//MARK: LocationSelection
//===============================================================================================


protocol LocationSelectionViewModelCoordinatorDelegate : class {
    func viewModelDidSelectLocation(_ location: LocationLite)
    func viewModelDidCancelSelection()
}

protocol LocationSelectionViewModelViewDelegate : class {
    
}

protocol LocationSelectionViewModelType : class {
    weak var coordinatorDelegate : LocationSelectionViewModelCoordinatorDelegate? { get set }
    weak var viewDelegate : LocationSelectionViewModelViewDelegate? { get set }
    
    //
    func cancel()
}

class LocationSelectionViewModel : LocationSelectionViewModelType {
    
    weak var coordinatorDelegate: LocationSelectionViewModelCoordinatorDelegate?
    weak var viewDelegate: LocationSelectionViewModelViewDelegate?
    
    func cancel() {
        self.coordinatorDelegate?.viewModelDidCancelSelection()
    }
}

//===============================================================================================
//MARK: LocationDetail
//===============================================================================================

protocol LocationDetailViewModelViewDelegate : class {
    
}

protocol LocationDetailViewModelCoordinatorDelegate : class {
    
}

typealias LocationDetailVMCoordinatorDelegate = ChildViewModelCoordinatorDelegate & LocationDetailViewModelCoordinatorDelegate


protocol LocationDetailViewModelType : class {
    weak var viewDelegate : LocationDetailViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : LocationDetailVMCoordinatorDelegate? { get set }
    
    func goBack()
    
}

class LocationDetailViewModel : LocationDetailViewModelType {
    
    weak var viewDelegate : LocationDetailViewModelViewDelegate?
    weak var coordinatorDelegate : LocationDetailVMCoordinatorDelegate?
    
    func goBack(){
        self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: .viewOnly)
    }
}
