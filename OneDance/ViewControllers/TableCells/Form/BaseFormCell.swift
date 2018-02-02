//
//  BaseFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/15/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

enum SelectionState {
    case selected
    case deselected
    
}

protocol SelectableCell : class {
    var selectionState : SelectionState { get set }
    
    func anotherCellSelected()
    
}

protocol CellSelectionDelegate : class {
    func cellSelectionChanged(_ cell: BaseFormCell, indexPath: IndexPath, state: SelectionState)
}

protocol ExpandingCellDelegate : class {
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?)
}


class BaseFormCell: UITableViewCell {

    override var designatedHeight: CGFloat{
        return 44.0
    }
    
    /// The block to call when the value of the text field changes.
    var valueChanged: ((Void) -> Void)?
    
    // Determines the selection state
    var selectionState : SelectionState = .deselected
    
    // Expanding
    weak var expandDelegate : ExpandingCellDelegate?
    
    // Selection
    var selectionDelegate : CellSelectionDelegate?

}

extension BaseFormCell : SelectableCell {
    
    func anotherCellSelected() {
        self.selectionState = .deselected
    }
}
