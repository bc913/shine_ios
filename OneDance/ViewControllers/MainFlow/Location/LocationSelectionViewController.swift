//
//  LocationSelectionViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/13/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class LocationSelectionViewController: UIViewController {

    var viewModel : LocationSelectionViewModel? {
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        
        // Do any additional setup after loading the view.
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        
    }
    
    @objc func cancel(){
        self.viewModel?.cancel()
    }
}

extension LocationSelectionViewController : LocationSelectionViewModelViewDelegate{}
