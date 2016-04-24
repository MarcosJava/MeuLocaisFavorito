//
//  ViewController.swift
//  LocaisFavoritos
//
//  Created by Marcos Felipe Souza on 26/12/15.
//  Copyright © 2015 Marcos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            initConfigMap()
        } else {
            
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]!
            
            self.map.addAnnotation(annotation)
            
            
        }
        
       
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: "actionLongPressed:")
        longPressed.minimumPressDuration = 2
        
        map.addGestureRecognizer(longPressed)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initConfigMap(){
        
        let latitude:CLLocationDegrees = -22.818270
        let longitude:CLLocationDegrees = -43.294509
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        map.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        map.setRegion(region, animated: true)
        
    }
    
    func actionLongPressed(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(map)
            let coordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
            
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
             
                var title:String?
                var address:String?
                var address2:String?
                
                if error == nil {
                    
                    if let p = placemarks?[0] {
                        
                        if p.subThoroughfare != nil {
                            address2 = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            address = p.thoroughfare!
                        }
                        
                        if address != nil {
                            title = "\(address!)"
                        }
                        if address2 != nil {
                            title = "\(title!) \(address2!)"
                        }
                        
                    }
                    
                    print(address!)
                    print(address2!)
                    print(title!)
                }
                
                if title?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                    title = "Adicionando em \(NSDate())"
                }
                
                places.append(["name":title!, "lat":"\(coordinate.latitude)", "lon":"\(coordinate.longitude)"])
                NSUserDefaults.standardUserDefaults().setObject(places, forKey: "myLocation")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = title!
                
                self.map.addAnnotation(annotation)
                
                
                
                
            })
            
           
            
            
        }
        
    }


}

