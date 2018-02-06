//
//  ShineSwitchCell.swift
//  OneDance
//
//  Created by Burak Can on 2/5/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class ShineSwitchCell: BaseFormCell {

    /// Container for the content
    var contentContainer = UIView()
    
    /// Label on the left side of the cell.
    var leftLabel = UILabel()
    
    /// Switch
    var switchControl = UISwitch()
    
    /// title for the cell
    var placeHolder : String?{
        didSet{
            self.leftLabel.text = placeHolder
        }
    }
    
    /// Displayed state for the switch control
    var displayedValue : Bool = false {
        didSet{
            self.switchControl.setOn(displayedValue, animated: false)
        }
    }
    
    /// Height
    var unexpandedHeight = CGFloat(44)
    
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
    
    fileprivate func setup(){
        
        self.clipsToBounds = true
        
        let views = [leftLabel, contentContainer, switchControl]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.contentContainer.addSubview(self.leftLabel)
        self.contentContainer.addSubview(self.switchControl)
        self.configureLayout()
        
        self.configureTappableCell()
        
        /// Reset switch control
        self.switchControl.setOn(displayedValue, animated: false)
        self.switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
    }
    
    
    /// Actions:
    @objc func switchToggled(){
        
        if self.selectionState == .deselected {
            self.updateCellSelection()
            self.notifyTableView()
        }
        
        handleValueChanged()
    }
    
    private func configureTappableCell(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellSelected(tapGestureRecognizer:)))
        
        self.contentContainer.isUserInteractionEnabled = true
        self.contentContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cellSelected(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil {
            print("Date picker tapped")
            self.updateCellSelection()
            self.notifyTableView()
        }
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ShineSwitchCell.identifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override var designatedHeight: CGFloat {
        
        return unexpandedHeight
    }
    
    private func configureLayout(){
        // Layout
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: contentContainer,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 44.0
            ),
            ])
        // Left label.
        self.contentContainer.addConstraints([
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        // Right label
        self.contentContainer.addConstraints([
            NSLayoutConstraint(
                item: switchControl,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: switchControl,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
        ])
        
        
        
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }

}
