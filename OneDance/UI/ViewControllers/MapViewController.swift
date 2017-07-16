//
//  MapViewController.swift
//  OneDance
//
//  Created by Burak Can on 7/15/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showUserLocationButton: UIButton!
    var locationManager = CLLocationManager()

    // MARK: - Internal Methods
    /*
     private func createLocationManager() -> CLLocationManager {
     let locManager = CLLocationManager()
     locManager.delegate = self
     locManager.desiredAccuracy = kCLLocationAccuracyBest
     locManager.requestWhenInUseAuthorization()
     print("osman osman 1")
     
     // Start to get current location
     if (CLLocationManager.locationServicesEnabled()) {
     print("osman osman 2")
     // TODO: Check its efficieny from IOS Apprentice Ray Wanderlich
     locManager.startUpdatingLocation()
     }
     
     return locManager
     }
     */
    
    private func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        
        
        
        // Start to get current location
        // TODO: Check startupdatingLocations() efficieny from IOS Apprentice Ray Wanderlich
        if (CLLocationManager.locationServicesEnabled()) {
            print("osman osman 2")
            //locationManager.startUpdatingLocation()
            
            if (CLLocationManager.authorizationStatus() == .notDetermined) {
                print("osman osman 5")
                locationManager.requestWhenInUseAuthorization()
            }
            print("osman osman 4")
            locationManager.requestLocation()
        }
        
        
    }
    
    private func configureMapView(){
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.showsScale = false
        mapView.showsCompass = true
        mapView.showsBuildings = false
        print("osman osman 3")
    }
    
    private func configureUserTrackingButton(){
        showUserLocationButton.layer.cornerRadius = 0.5 * showUserLocationButton.bounds.size.width
        
        showUserLocationButton.clipsToBounds = true
        showUserLocationButton.backgroundColor = UIColor.blue
        showUserLocationButton.setTitle("", for: .normal)
        
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureMapView()
        self.configureLocationManager()
        self.configureUserTrackingButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("lcoationMAnager.requestlocation() -> status = \(status.rawValue)")
        
        if (status == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if (status == .authorizedWhenInUse) {
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        // This code piece updates region in the map
        /*
         let userLocation = locations.last
         print("osman osman")
         
         let center = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
         
         print("latitude: \((userLocation?.coordinate.latitude)!) and longitude: \((userLocation?.coordinate.longitude)!)")
         
         // Small values of span corresponds to higher zoom levels
         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
         
         self.mapView.setRegion(region, animated: true)
         */
        
        
        // This code piece locates annotation and pin
        /*
         // Drop a pin at user's Current Location
         let myAnnotation: MKPointAnnotation = MKPointAnnotation()
         myAnnotation.coordinate = CLLocationCoordinate2DMake((userLocation?.coordinate.latitude)!, (userLocation?.coordinate.longitude)!);
         myAnnotation.title = "Current location"
         mapView.addAnnotation(myAnnotation)
         */
        
        
    }
    
    
}

// MARK: - MKMapViewDelegate
extension MapViewController : MKMapViewDelegate{
    /*
     // Keeps the user location as map center as the user location is updated.
     func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
     mapView.setCenter(userLocation.coordinate, animated: true)
     }
     */
}
