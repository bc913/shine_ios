//
//  DateFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/18/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class DateFormCell: BaseFormCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    weak var viewController : UIViewController?
    weak var tableView : UITableView?
    
    var dateFormatter = DateFormatter()
    
    private var tappedOnce : Bool = false
    
    var tapState : Bool {
        return self.tappedOnce
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.tappedOnce = !self.tappedOnce
            handleValueChanged()
        }
        
        // Configure the view for the selected state
    }
    
    var placeHolder : String?{
        didSet{
            self.title.text = placeHolder
        }
    }
  
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
        
        self.value.text = self.dateFormatter.string(from: Date())
    }
    
   
 
    // MARK: Interface
    
    
    
    /// Handle changes in the switch's value.
    func handleValueChanged() {
        valueChanged?()
        
        guard let dateIndexPath = getIndexPath?() else { return }
        
        guard dependentCells.count > 0 else { return }
        var indexPaths = [IndexPath]()
        
        self.tableView?.beginUpdates()
        
        // Create index paths for the dependent cells based on the index path of this cell.
        for row in 1...dependentCells.count {
            indexPaths.append(IndexPath(row: (dateIndexPath as NSIndexPath).row + row, section: (dateIndexPath as NSIndexPath).section))
        }
        
        guard !indexPaths.isEmpty else { return }
        
        if self.tapState {
            self.tableView?.insertRows(at: indexPaths, with: .bottom)
        } else {
            self.tableView?.deleteRows(at: indexPaths, with: .bottom)
        }
        
        self.tableView?.endUpdates()
    }
    
}

extension DateFormCell : DatePickerDelegate {
    func updateDate(selectedDate: Date) {
        self.value.text = self.dateFormatter.string(from: selectedDate)
    }
}
