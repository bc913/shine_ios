//
//  LocationSelectionViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/13/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSelectionViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?

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
        // Do any additional setup after loading the view.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

    }
    
    private func configureNavigationBar(){
        
        // Cancel
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        
    }
    
    @objc func cancel(){
        self.viewModel?.cancel()
    }
}

extension LocationSelectionViewController : LocationSelectionViewModelViewDelegate{}

extension LocationSelectionViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        //self.resultView.text = "\(place.name)" + "\n" + "\(String(describing: place.formattedAddress))" + "\n" + "\(place.coordinate)"
        //dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

// Handle the user's selection.
extension LocationSelectionViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place xname: \(place.name)")
        print("Place xaddress: \(place.formattedAddress)")
        print("Place xattributions: \(place.attributions)")
        
        let name = place.name
        let address = place.formattedAddress
        
        
        var city = ""
        var country = ""
        
        let addressComponents = place.addressComponents
        
        if addressComponents != nil {
            for comp in addressComponents! {
                if comp.type == "locality" || comp.type == "administrative_area_level_1" {
                    city = comp.name
                    continue
                }
                
                if comp.type == "country" {
                    country = comp.name
                    continue
                }
            }
        }
        
        let lat : Double = place.coordinate.latitude
        let lon : Double = place.coordinate.longitude
        
        
        if name.isEmpty || address == nil || address!.isEmpty || city.isEmpty || country.isEmpty {
            return
        }
        
        self.viewModel?.locationPicked(name: name, address: address!, city: city, country: country, lat: lat, lon: lon)
        
        //dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    //    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //    }
    //
    //    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //    }
}
