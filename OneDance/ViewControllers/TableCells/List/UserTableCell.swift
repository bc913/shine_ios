//
//  UserTableCell.swift
//  OneDance
//
//  Created by Burak Can on 1/1/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class UserTableCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var profileImageThumbView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
