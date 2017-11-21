//
//  LocationFormCell.swift
//  OneDance
//
//  Created by Burak Can on 11/18/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class LocationFormCell: BaseFormCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
    weak var viewController : UIViewController?
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(tapGestureRecognizer:)))
        
        self.containerView.isUserInteractionEnabled = true
        self.containerView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view) != nil {
            showLocationPickerViewController()
        }
    }
    
    private func showLocationPickerViewController(){
        let vc = UIViewController()
        self.viewController?.present(vc, animated: true, completion: nil)
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
}
