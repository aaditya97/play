//
//  ViewController.swift
//  Play
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var pokemon : [Pokemon] = []

    @IBOutlet weak var mapview: MKMapView!
    
    @IBAction func yourlocation(_ sender: AnyObject) {
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapview.setRegion(region, animated: true)
    
    }
    
    var manager = CLLocationManager()
    var update = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Checking the authorization status of the map, required for the app:
        self.manager.delegate = self
        self.mapview.delegate = self
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            
            self.mapview.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
             pokemon = bringAllPokemon()
            
            //Authorization status and location setting
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block:{
                (timer) in
                if let coordinate = self.manager.location?.coordinate{
                    let randomPokemon = Int(arc4random_uniform(UInt32(self.pokemon.count)))
                    let pokemon = self.pokemon[randomPokemon]
                    
                    let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                    annotation.coordinate = coordinate
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000))-500)/300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000))-500)/300000.0
                    
                    self.mapview.addAnnotation(annotation)

        }
                }
                    )
        }
            
        else {
            //Requesting authorization when not found:
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
   @objc(mapView:viewForAnnotation:) func mapView(_ mapview: MKMapView, viewFor annotation: MKAnnotation) ->MKAnnotationView?{
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
         var newFrame = annotationView.frame
        newFrame.size.width = 40
        newFrame.size.height = 40
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    
            func locationManager(_ manager: CLLocationManager , didUpdateLocations: [CLLocation])
            {
        
        if update < 4{
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapview.setRegion(region, animated: true)
           
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

