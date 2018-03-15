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
    func viewModelDidSelectLocation(_ location: Location)
    func viewModelDidCancelSelection()
}

protocol LocationSelectionViewModelViewDelegate : class {
    
}

protocol LocationSelectionViewModelType : class {
    weak var coordinatorDelegate : LocationSelectionViewModelCoordinatorDelegate? { get set }
    weak var viewDelegate : LocationSelectionViewModelViewDelegate? { get set }
    
    //
    
    var model : Location? { get set }
    
    func locationPicked(name: String, address: String, city: String, country: String, lat: Double, lon: Double)
    func cancel()
}

class LocationSelectionViewModel : LocationSelectionViewModelType {
    
    weak var coordinatorDelegate: LocationSelectionViewModelCoordinatorDelegate?
    weak var viewDelegate: LocationSelectionViewModelViewDelegate?
    
    // It might not be there initially and can be set later
    var model : Location?
    
    func locationPicked(name: String, address: String, city: String, country: String, lat: Double, lon: Double) {
        self.model = Location(id: "", name: name, address: address, city: city, country: country, lat: lat, lon: lon)
        
        self.coordinatorDelegate?.viewModelDidSelectLocation(self.model!)
    }
    
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
