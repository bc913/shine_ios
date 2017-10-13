//
//  DanceTypesViewModelInterface.swift
//  OneDance
//
//  Created by Burak Can on 10/10/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


protocol DanceTypesViewModelCoordinatorDelegate : class {
    func danceTypesViewModelDidSelect(data: IDanceType, _ viewModel:DanceTypesViewModelType)
}

protocol DanceTypesViewModelViewDelegate : class {
    func itemsDidChange(viewModel: DanceTypesViewModelType)
    func notifyUser(_ viewModel: DanceTypesViewModelType, _ title: String, _ message: String)
}

protocol DanceTypesViewModelType : class {
    var coordinatorDelegate : DanceTypesViewModelCoordinatorDelegate? { get set }
    var viewDelegate : DanceTypesViewModelViewDelegate? { get set }
    
    var model : DanceTypesModelType? { get set }
    
    var numberOfItems: Int { get }
    func itemAtIndex(_ index: Int) -> IDanceType?
    func useItemAtIndex(_ index: Int)
    
    var errorMessage : String { get }
}
