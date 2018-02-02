//
//  DatePickerCell.swift
//  OneDance
//
//  Created by Burak Can on 1/31/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit





class DatePickerCell: BaseFormCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var dateFormatter = DateFormatter()
    
    var placeHolder : String?{
        didSet{
            self.title.text = placeHolder
        }
    }
    
    @IBAction func dateValueUpdated(_ sender: Any) {
        
        if let picker = sender as? UIDatePicker{
            self.value.text = self.dateFormatter.string(from: picker.date)
        }
    }
    
    private func configureTappableCell(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellSelected(tapGestureRecognizer:)))
        
        self.containerView.isUserInteractionEnabled = true
        self.containerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cellSelected(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil {
            print("Date picker tapped")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureTappableCell()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
        
        self.value.text = self.dateFormatter.string(from: Date())
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        print("Date cell is selected: \(self.isSelected)")
        expandDelegate?.updateCellHeight(cell: self, height: 216.0, indexPath: nil)
    }
    
    override var designatedHeight: CGFloat {
        return self.isSelected ? 260.0 : 44.0
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
}


