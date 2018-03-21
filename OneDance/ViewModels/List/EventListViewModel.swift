//
//  EventListViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation


protocol EventListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel: EventListViewModelType)
}

protocol EventListViewModelCoordinatorDelegate : class {
    
}

typealias EventListVMCoordinatorDelegate = EventListViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol EventListViewModelType {
    weak var viewDelegate : EventListViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : EventListVMCoordinatorDelegate? { get set }
    
    var model : PageableEventListModelType? { get set }
    
    var source : ListSource { get set } // Originator of the list
    
    var count : Int { get }
    func itemAtIndex(_ index: Int) -> EventLite?
    
    var title : String { get set }
    
    func requestEventDetail(id: String)
    
}

protocol PageableEventListViewModelType : class, EventListViewModelType, PageableViewModel, Refreshable, NavigationalViewModel {
    
}

class EventListViewModel: PageableEventListViewModelType {
    
    weak var viewDelegate : EventListViewModelViewDelegate?
    weak var coordinatorDelegate : EventListVMCoordinatorDelegate?
    
    var model : PageableEventListModelType?
    
    var source : ListSource
    var sourceId : String
    
    var title : String
    
    init(source: ListSource, sourceId: String) {
        self.source = source
        self.sourceId = sourceId
        self.title = "Events"
    }
    
    // Error
    var errorMessage : String = ""
    
    // List
    var count : Int {
        return model != nil ? self.model!.count : 0
    }
    
    func itemAtIndex(_ index: Int) -> EventLite? {
        if self.count > 0 {
            return self.model!.items[index] as? EventLite
        } else {
            return nil
        }
    }
    
    // Page    
    func refresh() {
        self.model?.nextPageKey = ""
        self.loadItems(refresh: true)
    }
    var shouldShowLoadingCell: Bool = false
    
    func fetchNextPage() {
        self.loadItems()
    }
    
    
    func loadItems(refresh: Bool = false){
        
        let completionHandler = {(error: NSError?, userListModel: PageableEventListModelType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = userListModel {
                        
                        if refresh { self.model = model } //Refresh
                        else { // Fetch
                            for event in model.items {
                                
                                let hasIt = self.model?.items.contains { item in
                                    
                                    if event.id == item.id { return true }
                                    else { return false }
                                    
                                }
                                
                                if hasIt != nil && !hasIt!{ self.model?.items.append(event) }
                                
                            }//for
                            
                            self.model?.nextPageKey = model.nextPageKey
                        }
                        
                    }
                    
                    let hasKey = self.model == nil || (self.model != nil && self.model!.nextPageKey.isEmpty) ? false : true
                    self.shouldShowLoadingCell = hasKey
                    self.viewDelegate?.viewModelDidFinishUpdate(viewModel: self)
                    return
                    
                }
                
                self.errorMessage = error.localizedDescription
                
            }
            
            
        }
        
        ShineNetworkService.API.Common.getEventList(source: self.source, sourceId: self.sourceId, nextPageKey: self.model?.nextPageKey ?? "", mainThreadCompletionHandler: completionHandler)        
    }
    
    
    func requestEventDetail(id: String) {
        //
        self.coordinatorDelegate?.viewModelDidSelectEvent(eventID: id, requestedMode: .viewOnly)
    }
    
    func goBack(){
        self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: .viewOnly)
    }
}
