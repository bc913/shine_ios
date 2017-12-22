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
    
    /// A list of cells that are inserted/removed from the table based on the value of the switch.
    var dependentCells = [UITableViewCell]()
    
    /// A block to call to get the index path of this cell int its containing table.
    var getIndexPath: ((Void) -> IndexPath?)?
    
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
        
        if switchControl.isOn {
            tableView?.insertRows(at: indexPaths, with: .bottom)
        } else {
            tableView?.deleteRows(at: indexPaths, with: .bottom)
        }
    }
    
    
    
}
