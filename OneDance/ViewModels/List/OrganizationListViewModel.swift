//
//  OrganizationListViewModel.swift
//  OneDance
//
//  Created by Burak Can on 3/20/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation


protocol OrganizationListViewModelViewDelegate : class {
    func viewModelDidFinishUpdate(viewModel: OrganizationListViewModelType)
}

protocol OrganizationListViewModelCoordinatorDelegate : class {
    
}

typealias OrganizationListVMCoordinatorDelegate = OrganizationListViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate

protocol OrganizationListViewModelType {
    
    weak var viewDelegate : OrganizationListViewModelViewDelegate? { get set }
    weak var coordinatorDelegate : OrganizationListVMCoordinatorDelegate? { get set }
    
    var model : PageableOrganizationListModelType? { get set }
    
    var source : ListSource { get set } // Originator of the list
    
    var count : Int { get }
    func itemAtIndex(_ index: Int) -> OrganizationLite?
    
    var title : String { get set }
    
    func requestOrganizationDetail(id: String)
    
}

protocol PageableOrganizationListViewModelType : class, OrganizationListViewModelType, PageableViewModel, Refreshable, NavigationalViewModel {
    
}

class OrganizationListViewModel : PageableOrganizationListViewModelType {
    weak var viewDelegate : OrganizationListViewModelViewDelegate?
    weak var coordinatorDelegate : OrganizationListVMCoordinatorDelegate?
    
    var model : PageableOrganizationListModelType?
    
    var source : ListSource
    var sourceId : String
    
    var title : String
    
    init(source: ListSource, sourceId: String) {
        self.source = source
        self.sourceId = sourceId
        self.title = "Organizations"
    }
    
    // Error
    var errorMessage : String = ""
    
    // List
    var count : Int {
        return model != nil ? self.model!.count : 0
    }
    
    func itemAtIndex(_ index: Int) -> OrganizationLite? {
        if self.count > 0 {
            return self.model!.items[index]
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
        
        let completionHandler = {(error: NSError?, userListModel: PageableOrganizationListModelType?) in
            
            DispatchQueue.main.async {
                guard let error = error else {
                    
                    if let model = userListModel {
                        
                        if refresh { self.model = model } //Refresh
                        else { // Fetch
                            for org in model.items {
                                
                                let hasIt = self.model?.items.contains { item in
                                    
                                    if org.id == item.id { return true }
                                    else { return false }
                                    
                                }
                                
                                if hasIt != nil && !hasIt!{ self.model?.items.append(org) }
                                
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
        
    }
    
    
    func requestOrganizationDetail(id: String) {
        //
        self.coordinatorDelegate?.viewModelDidSelectOrganizationProfile(organizationID: id, requestedMode: .viewOnly)
    }
    
    func goBack(){
        self.coordinatorDelegate?.viewModelDidSelectGoBack(mode: .viewOnly)
    }
}
