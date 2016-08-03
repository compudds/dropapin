//
//  ViewController.swift
//  Learning Maps
//
//  Created by Rob Percival on 11/07/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var manager:CLLocationManager!

var count = 0
var saddr = String()
var daddr = String()

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet var myMap: MKMapView!
    
    
    @IBAction func findMe(sender: AnyObject) {
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //shows pin on map with title = current location and adds to places table
        let annotation = MKPointAnnotation()
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //let myHome = CLLocationCoordinate2DMake(latitude, longitude)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        myMap.setRegion(theRegion, animated: true)
        myMap.mapType = MKMapType.Standard
        //myMap.showsUserLocation = true
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(error)")
            
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
                } else {
                    city = ""
                }
                
                if ((p.postalCode) != nil) {
                    zip = p.postalCode!
                } else {
                    zip = ""
                }
                
                if ((p.addressDictionary!["Country"]) != nil) {
                    country = p.addressDictionary!["Country"]! as! String
                } else {
                    country = ""
                }

                
                annotation.coordinate = myLocation
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                annotation.title = title
                
                self.myMap.addAnnotation(annotation)
                let myAnnotationAtIndex = 0
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)
                
                var match = "no"
                
                for (var i = 0; i < places.count; i += 1) {
                    
                    //print("\(places[i]["name"]!) = \(title)")
                    
                    if (places[i]["name"]! == "\(title)") {
                        
                        match = "yes"
                        
                    }
                   
                    
                    
                }
                
                if match == "no" {
                    
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
                    
                    NSUserDefaults().setObject(places, forKey: "array" )

                    print("StoredItems: \(storedToDoItems)")
                   
                }
                
                daddr = "\(title1)"
                print(daddr)
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                        
                    }))
                    
                     self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
            
        })

        
    }
    
    
    @IBOutlet var latitude : UILabel!
    @IBOutlet var longitude : UILabel!
    @IBOutlet var address : UILabel!
    @IBOutlet var altitude : UILabel!
    @IBOutlet var speed : UILabel!
    @IBOutlet var heading : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        count = count + 1
        
        if activePlace == -1  {
            
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
            let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
            myMap.setRegion(theRegion, animated: true)
            myMap.mapType = MKMapType.Standard
            //myMap.showsUserLocation = true
            
            
            findLocation()
                
            
        } else {
        
        
        let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
        
        let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
        
        let latitude:CLLocationDegrees = lat
        
        let longitude:CLLocationDegrees = lon
        
        let latDelta:CLLocationDegrees = 0.01
        
        let lonDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myMap.setRegion(region, animated: true)
            
        myMap.showsUserLocation = true
            
        let annotation = MKPointAnnotation()
            
        annotation.coordinate = location
            
        annotation.title = places[activePlace]["name"]
            
        myMap.addAnnotation(annotation)
            
            
            
        }
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        
        uilpgr.minimumPressDuration = 0.35
        
        myMap.addGestureRecognizer(uilpgr)
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if addManually == "" {
            
        } else {
            
            manualLocation()
            
        }
        
      
    }
    
    
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
      if gestureRecognizer.state == UIGestureRecognizerState.Began {
        
        let touchPoint = gestureRecognizer.locationInView(self.myMap)
        
        let newCoordinate = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
        let loc = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(error)")
            
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
                } else {
                    city = ""
                }
                
                if ((p.postalCode) != nil) {
                    zip = p.postalCode!
                } else {
                    zip = ""
                }
                
                if ((p.addressDictionary!["Country"]) != nil) {
                    country = p.addressDictionary!["Country"]! as! String
                } else {
                    country = ""
                }

                var myAnnotationAtIndex = 0
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                annotation.title = title
                
                self.myMap.addAnnotation(annotation)
                
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)
                
                places.append(["name":"\(title)","lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                
                let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
                
                NSUserDefaults().setObject(places, forKey: "array" )
                
                print("StoredItems: \(storedToDoItems)")
                
                myAnnotationAtIndex = myAnnotationAtIndex + 1
                
                daddr = "\(title1)"
                
            }
            
            })
            
            
        }

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        
        
        if count == 0 {
            
            places.removeAtIndex(0)
            
        } else {
            
            
        }

        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        myMap.showsUserLocation = true
        
        myMap.setRegion(region, animated: true)
        
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(error)")
            
            } else {
                
                let p = CLPlacemark(placemark: (placemarks?[0])! as CLPlacemark)
                
                var subThoroughfare:String
                var thoroughfare:String
                var zip:String
                
                if ((p.subThoroughfare) != nil) {
                    subThoroughfare = p.subThoroughfare!
                    thoroughfare = p.thoroughfare!
                    zip = p.postalCode!
                } else {
                    subThoroughfare = ""
                    thoroughfare = ""
                    zip = ""
                }
                
                self.address.text =  "\(subThoroughfare) \(p.thoroughfare) \n \(p.subLocality) \n \(p.subAdministrativeArea) \n \(p.postalCode) \(p.country)"
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                        manager.stopUpdatingLocation()

                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
        })
        
        saddr = "\(latitude),\(longitude)"
        print("saddr: \(saddr)")


    }
    
    func manualLocation() {
        
        if addManually != "" {
            
            let annotation = MKPointAnnotation()
            
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let address = addManually
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let p = placemarks?.first {
                    
                    let coordinates:CLLocationCoordinate2D = p.location!.coordinate
                    print(coordinates)
                    
                    let latitude:CLLocationDegrees = coordinates.latitude
                    let longitude:CLLocationDegrees = coordinates.longitude
                    
                    let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
                    self.myMap.setRegion(theRegion, animated: true)
                    self.myMap.mapType = MKMapType.Standard

                    
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
                    } else {
                        city = ""
                    }
                    
                    if ((p.postalCode) != nil) {
                        zip = p.postalCode!
                    } else {
                        zip = ""
                    }
                    
                    if ((p.addressDictionary!["Country"]) != nil) {
                        country = p.addressDictionary!["Country"]! as! String
                    } else {
                        country = ""
                    }

                    
                    
                    annotation.coordinate = myLocation
                    
                    let title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                    
                    annotation.title = title
                    
                    self.myMap.addAnnotation(annotation)
                    let myAnnotationAtIndex = 0
                    self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)
                    
                    
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    
                    let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
                    
                    NSUserDefaults().setObject(places, forKey: "array" )
                    
                    print("StoredItems: \(storedToDoItems)")
                    
                    }
            })
            
            
          addManually = ""
            
            
        } else {
            
            
            
        }
        
    }
    
    func findLocation() {
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //shows pin on map with title = current location and adds to places table
        let annotation = MKPointAnnotation()
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //var myHome:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        myMap.setRegion(theRegion, animated: true)
        myMap.mapType = MKMapType.Standard
        //myMap.showsUserLocation = true
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(error)")
                
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
                } else {
                    city = ""
                }
                
                if ((p.postalCode) != nil) {
                    zip = p.postalCode!
                } else {
                    zip = ""
                }
                
                if ((p.addressDictionary!["Country"]) != nil) {
                    country = p.addressDictionary!["Country"]! as! String
                } else {
                    country = ""
                }

                
                
                annotation.coordinate = myLocation
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                annotation.title = title
                
                self.myMap.addAnnotation(annotation)
                let myAnnotationAtIndex = 0
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)

                var match = "no"
                
                for (var i = 0; i < places.count; i += 1) {
                   
                    if (places[i]["name"]! == "\(title)") {
                        
                        match = "yes"
                        
                    }
                    
                    
                }
                
                if match == "no" {
                    
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    
                    let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
                    
                    NSUserDefaults().setObject(places, forKey: "array" )
                    
                    print("StoredItems: \(storedToDoItems)")
                    
                }

                daddr = "\(title1)"
                print("\(title1)")
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
            
        })

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

