//
//  ViewController.swift
//  Play
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var update = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checking the authorization status of the map, required for the app:
        self.manager.delegate = self
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
        }
        else {
            //Requesting authorization when not found:
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if update < 4{
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapView.setRegion(region, animated: true)
        }
        else
        {
            update += 1
        }
            self.manager.stopUpdatingLocation()
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

