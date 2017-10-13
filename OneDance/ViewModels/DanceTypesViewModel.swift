//
//  DanceTypesViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

class DanceTypesViewModel: DanceTypesViewModelType {
    
    weak var coordinatorDelegate: DanceTypesViewModelCoordinatorDelegate?
    weak var viewDelegate: DanceTypesViewModelViewDelegate?
    
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
        
        
        ShineNetworkService().getDanceTypes(mainThreadCompletionHandler: modelCompletionHandler)
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
}
