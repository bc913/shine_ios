//
//  DanceTypesViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

protocol DanceTypesViewModelCoordinatorDelegate : class {
    func danceTypesViewModelDidSelect(data: IDanceType, _ viewModel:DanceTypesViewModelType)
    func userDidFinishDanceTypesSelection(viewModel: DanceTypesViewModelType)
    func userDidCancelDanceTypeSelection()
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
    
    var selectedItems : [IDanceType]? { get set }
    
    func submit()
    func cancelSelection()
    func doneSelecting()
    
}


class DanceTypesViewModel: DanceTypesViewModelType {
    
    weak var coordinatorDelegate: DanceTypesViewModelCoordinatorDelegate?
    weak var viewDelegate: DanceTypesViewModelViewDelegate?
    var selectedItems: [IDanceType]?
    
    
    private var items : [IDanceType]? {
        didSet{
            viewDelegate?.itemsDidChange(viewModel: self)
        }
    }
    
    var model: DanceTypesModelType? {
        didSet{
            self.items = nil
            self.model?.items({ (items) in
                self.items = items
            })
        }
    }
    
    
    /// Errors
    fileprivate(set) var errorMessage: String = "" {
        didSet {
            if oldValue != errorMessage {
                viewDelegate?.notifyUser(self, "Error", errorMessage)
            }
        }
    }
    
    init() {
        
        let modelCompletionHandler = { (error: NSError?, data:[IDanceType]?) in
            //Make sure we are on the main thread
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
                guard let error = error else {
                    self.model = DanceTypesModel(items: data)
                    return
                }
                self.model = DanceTypesModel(items: nil)
                self.errorMessage = error.localizedDescription
                
            }
            
        }
        
        ShineNetworkService.API.User.getDanceTypes(mainThreadCompletionHandler: modelCompletionHandler)
        print("DanceTypeViewModel.init() after network request")
        
        self.selectedItems = [IDanceType]()
    }
    
    var numberOfItems: Int {
        if let items = self.items {
            return items.count
        }
        
        return 0
    }
    
    func itemAtIndex(_ index: Int) -> IDanceType? {
        if let items = self.items, items.count > index {
            return items[index]
        }
        
        return nil
    }
    
    func useItemAtIndex(_ index: Int) {
        if let items = self.items, let coordinatorDelegate = self.coordinatorDelegate, index < items.count {
            coordinatorDelegate.danceTypesViewModelDidSelect(data: items[index], self)
        }
    }
    
    
    func submit(){
        print("DanceTypesVM :: Submit")
        print("self.selectedItems : \(String(describing: self.selectedItems))")
        
        
        
        self.coordinatorDelegate?.userDidFinishDanceTypesSelection(viewModel: self)
        
    }
    
    func cancelSelection() {
        self.coordinatorDelegate?.userDidFinishDanceTypesSelection(viewModel: self)
    }
    
    func doneSelecting() {
        //
        self.submit()        
        
    }
}
