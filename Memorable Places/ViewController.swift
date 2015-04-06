//
//  ViewController.swift
//  Memorable Places
//
//  Created by Jaime Young on 4/5/15.
//  Copyright (c) 2015 Jaime Young. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var manager: CLLocationManager!
    
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager = CLLocationManager()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if activePlace == -1 {
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        }
        
        else {
            
            
            
            var latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            
            var longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            var latDelta:CLLocationDegrees = 0.01
            
            var lonDelta:CLLocationDegrees = 0.01
            
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            
            var annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            
            annotation.title = places[activePlace]["name"]
            
            self.map.addAnnotation(annotation)
            
            
            
        }
        
     
        
        // long press functionality
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        // remember we use the colon after action to pass on information to the action method
        
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
        
    }
    
    // long press function 
    
    func action(gestureRecognizer:UIGestureRecognizer) {
    
        // a way of looking for just the first indication of a long press
        // code done once per long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
        
            var touchPoint =  gestureRecognizer.locationInView(self.map)
            
            var newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            // reverse geo coder
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                
                
                if(error == nil){
                    
                    if let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark) {
                        
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                        
                            subThoroughfare = p.subThoroughfare
                        }
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare
                        }
                        
                      title = "\(subThoroughfare) \(thoroughfare)"
                        
                    }
                    
                }
                
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                var annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                annotation.title = title
                
                self.map.addAnnotation(annotation)

                
                
            })
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as CLLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,lonDelta)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

