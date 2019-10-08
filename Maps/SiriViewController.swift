//
//  SiriViewController.swift
//  Maps
//
//  Created by Eric Cook on 3/27/19.
//  Copyright © 2019 Appfish. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SiriViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        siri()
        
    }


    func updateLocation() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func siri() {
        
        let activity = NSUserActivity(activityType: "com.bettersearchllc.Maps.dropPin")
        activity.title = "Drop a Pin"
        activity.userInfo = ["Message" : "Here is my location"]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("xyz")
        view.userActivity = activity
        activity.becomeCurrent()
        
        //shows pin on map with title = current location and adds to places table
        
        updateLocation()
        
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(error!)")
                
            } else {
                
                let p = CLPlacemark(placemark: (placemarks?[0])! as CLPlacemark)
                
                var subThoroughfare:String
                var thoroughfare:String
                var city:String
                var state:String
                var zip:String
                var country:String
                
                if ((p.subThoroughfare) != nil) {
                    subThoroughfare = p.subThoroughfare!
                } else {
                    subThoroughfare = ""
                }
                
                if ((p.thoroughfare) != nil) {
                    thoroughfare = p.thoroughfare!
                } else {
                    thoroughfare = ""
                }
                
                if ((p.administrativeArea) != nil) {
                    state = p.administrativeArea!
                } else {
                    state = ""
                }
                
                if ((p.locality) != nil) {
                    city = p.locality!
                    //city = p.addressDictionary!["City"]! as! String
                } else {
                    city = ""
                }
                
                
                if ((p.postalCode) != nil) {
                    zip = p.postalCode!
                } else {
                    zip = ""
                }
                
                if ((p.country) != nil) {
                    country = p.country!
                } else {
                    country = ""
                }
                
                
                
                //annotation.coordinate = myLocation
                
                //self.rotateLabel(annotation)
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.replacingOccurrences(of: " ", with: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                
                UserDefaults.standard.set(places, forKey: "array" )
                
                UserDefaults.standard.synchronize()
                
                
                daddr = "\(title1)"
                print("\(title1)")
                
            }
            
        })
        
        manager.stopUpdatingLocation()  //startUpdatingLocation()
        
        performSegue(withIdentifier: "siriToPlaces", sender: self)
        
    }
 
}
