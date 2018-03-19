//
//  Interfaces.swift
//  OneDance
//
//  Created by Burak Can on 3/10/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// This file includes common interfaces for the view models.


// ========
// Common
//=========

enum ShineMode {
    case edit
    case viewOnly
    case create
    case delete
    case select
}

protocol Refreshable : class {
    func refresh()
}



// ========
// Models
//=========


protocol PageableModel {
    var nextPageKey : String { get set }
}

protocol UserListModelType {
    var items : [UserLiteType] { get set }
    var count : Int { get }
}

protocol CommentListModelType {
    var items : [PostCommentType] { get set }
    var count : Int { get }
}


// ========
// ViewModel
//=========

/// To support modal view controllers
protocol PresentableViewModel {
    func present()
}

/// To support navigation oriented view controllers
protocol NavigationalViewModel {
    func goBack()
}

protocol PageableViewModel {
    func fetchNextPage()
    var shouldShowLoadingCell : Bool { get set }
    
}

protocol LocationableViewModel : class {
    func updateLocation(_ location: Location)
}

protocol DanceTypeableViewModel : class {
    func updateDanceTypes(_ dances: [IDanceType])
}



