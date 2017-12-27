//
//  TimeLineViewModel.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

typealias TimeLineVMCoordinatorDelegate = TimeLineViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol TimeLineViewModelViewDelegate : class {
    
}

protocol TimeLineViewModelCoordinatorDelegate : class {
    
    func viewModelDidSelectCreateEvent(viewModel: TimeLineViewModelType)
    func viewModelDidSelectCreateOrganization(viewModel: TimeLineViewModelType)
    
    
    // Handle the refresh inside viewModel and update viewDelegate
}



protocol TimeLineViewModelType : class {
    
    weak var coordinatorDelegate : TimeLineViewModelCoordinatorDelegate? { get set }
    weak var viewDelegate : TimeLineViewModelViewDelegate? { get set }
    
    func createOrganization()
    func createEvent()
}

class TimeLineViewModel : TimeLineViewModelType {
    
    weak var coordinatorDelegate: TimeLineViewModelCoordinatorDelegate? {
        didSet{
            print("TimelineCoordinatorDelagate::Didset")
        }
    }
    weak var viewDelegate: TimeLineViewModelViewDelegate?
    
    
    func createOrganization() {
        self.coordinatorDelegate?.viewModelDidSelectCreateOrganization(viewModel: self)
    }
    
    func createEvent() {
        self.coordinatorDelegate?.viewModelDidSelectCreateEvent(viewModel: self)
    }
    
    
    
}
