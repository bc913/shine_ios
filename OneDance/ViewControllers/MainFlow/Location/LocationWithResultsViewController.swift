//
//  LocationWithResultsViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/13/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit
import MapKit

class LocationWithResultsViewController: UIViewController {

    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var resultsSegmentedControl: UISegmentedControl!
    
    
    var viewModel : LocationDetailViewModelType?{
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureResultsControlType()
        self.configureNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    private func configureResultsControlType() {
        self.resultsSegmentedControl.setTitle("Parties", forSegmentAt: 0)
        self.resultsSegmentedControl.setTitle("Classes", forSegmentAt: 1)
        self.resultsSegmentedControl.setTitle("Organizations", forSegmentAt: 2)
        self.resultsSegmentedControl.setTitle("Posts", forSegmentAt: 3)
    }
    
    private func configureNavigationBar(){
        
        if !self.isFirstViewController {
            
            // Customize navigation for back
            self.navigationItem.hidesBackButton = true
            
            let newBackButton = UIBarButtonItem(image: UIImage(named:"back_white"), style: .plain, target: self, action: #selector(goBack(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
        
        
    }
    
    @objc
    func goBack(sender: UIBarButtonItem){
        self.viewModel?.goBack()
    }

}

extension LocationWithResultsViewController : LocationDetailViewModelViewDelegate {
    
}
