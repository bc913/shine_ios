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

enum ExpandState {
    case expandable
    case nonExpandable
}

protocol SelectableCell : class {
    var selectionState : SelectionState { get set }
    
    func updateCellSelection()
    
}

protocol CellSelectionDelegate : class {
    func cellSelectionChanged(_ cell: BaseFormCell, state: SelectionState, indexPath: IndexPath?)
    func cellSelectedForLocation()
}

protocol ExpandingCellDelegate : class {
    func updateCellHeight(cell: BaseFormCell, height: CGFloat, indexPath: IndexPath?)
}


/** 
 Inherit from this table cell if you have form type table view
 
 - Parameter osman: OSman toptur
 
 */
class BaseFormCell: UITableViewCell {

    override var designatedHeight: CGFloat{
        return 44.0
    }
    
    /// The block to call when the value of the text field changes.
    var valueChanged: ((Void) -> Void)?
    
    /// A block to call to get the index path of this cell int its containing table.
    var getIndexPath: ((Void) -> IndexPath?)?
    
    /// A list of cells that are inserted/removed from the table based on the value of the switch.
    var dependentCells = [BaseFormCell]()
    
    /// Override this in subclasses if needed
    func clearCellState(){
        if self.selectionState == .selected {
            self.updateCellSelection()
        }
    }
    
    /// Set this as true in subclasses if the cell is collapsible
    var isCollapsible : Bool?
    
    // Determines the selection state
    internal var selectionState : SelectionState = .deselected {
        didSet{
            if let collapsible = self.isCollapsible {
                if collapsible {
                    self.expandDelegate?.updateCellHeight(cell: self, height: 100.0, indexPath: nil)
                }
            }
            
        }
    }
    
    // Expanding
    weak var expandDelegate : ExpandingCellDelegate?
    
    // Selection
    weak var selectionDelegate : CellSelectionDelegate?

}

extension BaseFormCell : SelectableCell {
    
    func updateCellSelection() {
        if self.selectionState == .deselected {
            self.selectionState = .selected
        }
        else{
            self.selectionState = .deselected
        }
    }
    
    func notifyTableView(){
        // Notify the table view
        let index = self.getIndexPath?()
        self.selectionDelegate?.cellSelectionChanged(self, state: selectionState, indexPath: index)
    }
    
    func notifyForLocation(){
        self.selectionDelegate?.cellSelectedForLocation()
    }
}

