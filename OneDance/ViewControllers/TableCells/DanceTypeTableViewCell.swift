//
//  DanceTypeTableViewCell.swift
//  OneDance
//
//  Created by Burak Can on 10/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class DanceTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var danceTypeLabel: UILabel!
    
    var item: IDanceType? {
        didSet{
            if let item = self.item {
                self.danceTypeLabel.text = item.name
            } else {
                self.danceTypeLabel.text = "Unknown"
            }
        }
    }
    
    var defaultBorderColor : CGColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        // For accessory view background color
        self.contentView.superview?.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.accessoryView?.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.danceTypeLabel.textColor = UIColor.white
        
        self.defaultBorderColor = self.layer.borderColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
//        // Update the background colors to hide highlighting
//        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
//        // For accessory view background color
//        self.contentView.superview?.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
//        self.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
//        self.accessoryView?.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
    }
    
}
