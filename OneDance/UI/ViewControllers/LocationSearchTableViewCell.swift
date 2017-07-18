//
//  LocationSearchTableViewCell.swift
//  OneDance
//
//  Created by Burak Can on 7/17/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class LocationSearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var locationAddress: UILabel!
    
    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationName.font = locationName.font.withSize(16)
        locationAddress.font = locationAddress.font.withSize(11)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
