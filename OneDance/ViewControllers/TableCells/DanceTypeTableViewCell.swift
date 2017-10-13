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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
