//
//  SwitchFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/17/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class SwitchFormCell: BaseFormCell {

    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.switchControl.setOn(false, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var placeHolder : String?{
        didSet{
            self.title.text = placeHolder
        }
    }
    
    var displayedValue : Bool = false {
        didSet{
            self.switchControl.setOn(displayedValue, animated: false)
        }
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    
    /// The table view controller of the table view that contains this cell. Used when inserting and removing cells that are conditionally displayed by the switch.
    weak var tableView : UITableView?
    
    /// A boolean that toggles the switch.
    var isOn: Bool {
        get {
            return switchControl.isOn
        }
        set (newValue) {
            let changed = switchControl.isOn != newValue
            switchControl.isOn = newValue
            if changed {
                handleValueChanged()
            }
        }
    }
    
    // MARK: Interface
    
    @IBAction func toggled(_ sender: Any) {
        
        if self.selectionState == .deselected {
            self.updateCellSelection()
            self.notifyTableView()
        }
        
        handleValueChanged()
    }
    
    /// Handle changes in the switch's value.
    func handleValueChanged() {
        valueChanged?()
        
        guard let switchIndexPath = getIndexPath?() else { return }
        
        guard dependentCells.count > 0 else { return }
        var indexPaths = [IndexPath]()
        
        // Create index paths for the dependent cells based on the index path of this cell.
        for row in 1...dependentCells.count {
            indexPaths.append(IndexPath(row: (switchIndexPath as NSIndexPath).row + row, section: (switchIndexPath as NSIndexPath).section))
        }
        
        guard !indexPaths.isEmpty else { return }
        
        self.tableView?.beginUpdates()
        if switchControl.isOn {
            tableView?.insertRows(at: indexPaths, with: .bottom)
        } else {
            tableView?.deleteRows(at: indexPaths, with: .bottom)
        }
        self.tableView?.endUpdates()
    }
    
    
    
}
