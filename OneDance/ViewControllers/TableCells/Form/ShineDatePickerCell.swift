//
//  ShineDatePickerCell.swift
//  OneDance
//
//  Created by Burak Can on 2/3/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class ShineDatePickerCell: BaseFormCell {
    
    /// Seperator
    class DVColorLockView:UIView {
        
        var lockedBackgroundColor:UIColor {
            set {
                super.backgroundColor = newValue
            }
            get {
                return super.backgroundColor!
            }
        }
        
        override var backgroundColor:UIColor? {
            set {
            }
            get {
                return super.backgroundColor
            }
        }
    }
    
    
    
    /// Container for the labels
    var contentContainer = UIView()
    
    /// title for the cell
    var placeHolder : String?{
        didSet{
            self.leftLabel.text = placeHolder
        }
    }
    
    /// Label on the left side of the cell.
    open var leftLabel = UILabel()
    /// Label on the right side of the cell.
    open var rightLabel = UILabel()
    /// Color of the right label. Default is the color of a normal detail label.
    open var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) {
        didSet {
            rightLabel.textColor = rightLabelTextColor
        }
    }
    
    /// Seperator
    var seperator = DVColorLockView()
    
    /// Date picker
    var datePickerContainer = UIView()
    /// The selected date
    var dateFormatter = DateFormatter()
    var date : Date =  Date() {
        didSet{
            self.rightLabel.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    /// The datepicker embeded in the cell.
    open var datePicker: UIDatePicker = UIDatePicker()
    
    /// Callback for the date picker
    @objc func datePicked() {
        self.date = self.datePicker.date
        self.valueChanged?()
    }
    
    /// Is the cell expanded?
    open var expanded = false
    var unexpandedHeight = CGFloat(44)
    
    fileprivate func setup(){
        
        self.clipsToBounds = true
        
        let views = [leftLabel, rightLabel, contentContainer, seperator, datePickerContainer, datePicker]
        for view in views {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // This view is collapsible.
        self.isCollapsible = true
        
        datePickerContainer.clipsToBounds = true
        datePickerContainer.addSubview(datePicker)
        
        // Dateformatter style
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
        
        
        // Add a seperator between the date text display, and the datePicker. Lighter grey than a normal seperator.
        seperator.lockedBackgroundColor = UIColor(white: 0, alpha: 0.1)
        datePickerContainer.addSubview(seperator)
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1.0,
                constant: 0.5
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        // Picker constraints.
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        
        // Right label
        self.rightLabel.text = self.dateFormatter.string(from: Date())
        
        rightLabel.textColor = rightLabelTextColor
        
        
        self.contentContainer.addSubview(self.leftLabel)
        self.contentContainer.addSubview(self.rightLabel)
        
        // Label Containers
        
        
        
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
                item: rightLabel,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
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
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: contentContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 1
            ),
            ])
        
        
        datePicker.addTarget(self, action: #selector(datePicked), for: UIControlEvents.valueChanged)
        self.configureTappableCell()
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
    
    override func clearCellState() {
        self.datePicked()
        super.clearCellState()
    }
    
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ShineDatePickerCell.identifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override var designatedHeight: CGFloat {
        
        let expandedHeight = unexpandedHeight + CGFloat(datePicker.frame.size.height)
        return self.selectionState == .selected ? expandedHeight : unexpandedHeight
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }


}
