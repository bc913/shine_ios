//
//  ViewInterfaces.swift
//  OneDance
//
//  Created by Burak Can on 3/9/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

// Cells


/// If the cell will respond when username (owner) is tapped
protocol UserNameTappableCell {
    var ownerHandler : ((Void) -> (Void))? { get set }
}

protocol LikeableView{
    //var determineLikeCounter : ((Void) -> (Void))? { get set }
    var likeHandler : ((Void) -> (Void))? { get set }
    var reomoveLikeHandler : ((Void) -> (Void))? {get set }
}


protocol CommentableViewController {
    
}
