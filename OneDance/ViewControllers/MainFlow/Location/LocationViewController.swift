//
//  LocationViewController.swift
//  OneDance
//
//  Created by Burak Can on 2/19/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

protocol LocationViewModelCoordinatorDelegate : class {
    func viewModelDidSelectLocation()
    func viewModelDidCancelSelection()
}

protocol LocationViewModelViewDelegate : class {

}

protocol LocationPickerViewModelType : class {
    weak var coordinatorDelegate : LocationViewModelCoordinatorDelegate? { get set }
    weak var viewDelegate : LocationViewModelViewDelegate? { get set }
    
    //
    func cancel()
}

class LocationPickerViewModel : LocationPickerViewModelType {
    weak var coordinatorDelegate: LocationViewModelCoordinatorDelegate?
    weak var viewDelegate: LocationViewModelViewDelegate?
    
    func cancel() {
        self.coordinatorDelegate?.viewModelDidCancelSelection()
    }
}


class LocationViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    
    var viewModel : LocationPickerViewModelType? {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension LocationViewController : LocationViewModelViewDelegate{}
