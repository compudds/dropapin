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
var myLocations: [CLLocation] = []

var count = 0
var saddr = String()
var daddr = String()

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
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
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        //let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        //myMap.setRegion(theRegion, animated: true)
        myMap.mapType = MKMapType.Standard
        let newCamera = MKMapCamera()
        newCamera.heading = 90.0
        myMap.setCamera(newCamera, animated: true)
        
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
                
                if ((p.addressDictionary!["City"]) != nil) {
                    //city = p.locality!
                    city = p.addressDictionary!["City"]! as! String
                } else {
                    city = ""
                }

                /*if ((p.locality) != nil) {
                    city = p.locality!
                } else {
                    city = ""
                }*/
                
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
                
                //self.rotateLabel(annotation)
                
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
                
                if ((subThoroughfare >= "5" && subThoroughfare <= "20" ) && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
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
        
        myMap.delegate = self
        
        count = count + 1
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        if activePlace == -1  {
            
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingHeading()
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
            //let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
            //let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
            //let latDelta:CLLocationDegrees = 0.01
            //let longDelta:CLLocationDegrees = 0.01
            //let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            //let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            //let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
            //myMap.setRegion(theRegion, animated: true)
            myMap.mapType = MKMapType.Standard
            
            let camera = MKMapCamera()
            camera.heading = 0.0
            camera.centerCoordinate = myMap.centerCoordinate
            //camera.pitch = 0.0
            //camera.altitude = 400.0
            //myMap.setCamera(camera, animated: true)

            //myMap.setRegion(theRegion, animated: true)
            myMap.mapType = MKMapType.Standard
            myMap.showsPointsOfInterest = true
            if #available(iOS 9.0, *) {
                myMap.showsTraffic = true
                myMap.showsBuildings = true
            } else {
                // Fallback on earlier versions
            }
            
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
            
        //self.rotateLabel(annotation)
            
        }
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        
        uilpgr.minimumPressDuration = 0.35
        
        myMap.addGestureRecognizer(uilpgr)
        
        
    }
    
    //Rotate Annotations to always face North
    /*
    func rotateLabel(label: MKAnnotation) {
        
        let transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180)
        myMap.transform = transform
        //UIView.commitAnimations()
    }
    
    func rotateView(label: UILabel) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.05)
        UIView.setAnimationDelegate(label)
        //var transform = label.transform
        let transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180)
        label.transform = transform
        UIView.commitAnimations()
    }
    */
    
    var heading1 = CLLocationDirection() * -1
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let speedMph = Int(speed2 * 2.23694)
        
        print("New Heading: \(newHeading.magneticHeading) Speed: \(speedMph)")
        
        let nhf = CGFloat(newHeading.magneticHeading)
        
        heading1 = newHeading.magneticHeading
        
        /*if (speedMph <= 0) {
            
        } else {
        
            //myMap.setUserTrackingMode(.FollowWithHeading, animated: true)
            //myMap.transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180)  //( -1 * 3.14159 / 180)
            let camera = MKMapCamera()
            camera.heading = 0.0
            camera.centerCoordinate = myMap.centerCoordinate
            //camera.pitch = 80.0
            camera.altitude = 100.0
            //myMap.setCamera(camera, animated: true)
            
        }*/
        
        //North
        if (nhf >= CGFloat(337.5000) && nhf < CGFloat(360.0000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180)  //( -1 * 3.14159 / 180)
            speed.text = "\(speedMph) mph"
            heading.text = "North"
            
           
        }
        
        if (nhf >= CGFloat(0.0000) && nhf < CGFloat(22.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180)  //( -1 * 3.14159 / 180)
            speed.text = "\(speedMph) mph"
            heading.text = "North"
            
        }
        
        //NE
        if (nhf >= CGFloat(22.5000) && nhf < CGFloat(67.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -1 * 3.14159 / 180 )  //( -1 * 3.14159 / 180)
              //myMap.setUserTrackingMode(.FollowWithHeading, animated: true)
            speed.text = "\(speedMph) mph"
            heading.text = "NE"
            
        }
        //East
        if (nhf >= CGFloat(67.5000) && nhf < CGFloat(112.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -90 * 3.14159 / 180 ) //( -90 * 3.14159 / 180 )
              //myMap.transform = CGAffineTransformRotate(self.myMap.transform, nhf)
            speed.text = "\(speedMph) mph"
            heading.text = "East"
            
            
        }
        //SE
        if (nhf >= CGFloat(112.5000) && nhf < CGFloat(157.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -135 * 3.14159 / 180 )  //( -90 * 3.14159 / 180 )
            speed.text = "\(speedMph) mph"
            heading.text = "SE"
            
        }
        //South
        if (nhf >= CGFloat(157.5000) && nhf < CGFloat(202.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -180 * 3.14159 / 180 )  //( -180 * 3.14159 / 180 )
            speed.text = "\(speedMph) mph"
            heading.text = "South"
            
            
        }
        //SW
        if (nhf >= CGFloat(202.5000) && nhf < CGFloat(247.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -225 * 3.14159 / 180 )  //( -180 * 3.14159 / 180 )
            speed.text = "\(speedMph) mph"
            heading.text = "SW"
            
        }
        //West
        if (nhf >= CGFloat(247.5000) && nhf < CGFloat(292.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -270 * 3.14159 / 180 )  //( -270 * 3.14159 / 180 )
              //myMap.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)

            speed.text = "\(speedMph) mph"
            heading.text = "West"
         
        }
        //NW
        if (nhf >= CGFloat(292.5000) && nhf < CGFloat(337.5000)) {
            
            //myMap.transform = CGAffineTransformMakeRotation( -325 * 3.14159 / 180 )  //( -270 * 3.14159 / 180 )
            speed.text = "\(speedMph) mph"
            heading.text = "NW"
            
        }
        
    }
    
    var speed2 = CLLocationSpeed()
    
    func centerMapOnLocation(location: CLLocation) {
        
        var speed1: CLLocationSpeed = CLLocationSpeed()
        speed1 = location.speed
        speed2 = speed1
        print("Speed: \(speed1) Heading: \(heading1)")
        
        if (speed1 <= 0.0000) { //0mph
            
            //let regionRadius: CLLocationDistance = 100
            
            //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            
           // myMap.setRegion(coordinateRegion, animated: true)
            
            let camera = MKMapCamera()
            camera.centerCoordinate = myMap.centerCoordinate
            camera.altitude = 800.0
            camera.pitch = 50.0
            //camera.heading = 0.0
            //myMap.setCamera(camera, animated: true)
            
        }
        
        if (speed1 > 0.0000 && speed1 < 8.9408) { //>0-20mph
            
            if #available(iOS 9.0, *) {
                let rotatedCamera = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 800.0, pitch: 50.0, heading: heading1)
                myMap.setCamera(rotatedCamera, animated: true)
            } else {
                
                let regionRadius: CLLocationDistance = 100
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                
                myMap.setRegion(coordinateRegion, animated: true)

            }
           
            
        }
        
        if (speed1 > 8.9408 && speed1 < 20.1168) { //20-45mph
            
            if #available(iOS 9.0, *) {
                let rotatedCamera = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 1100.0, pitch: 50.0, heading: heading1)
                myMap.setCamera(rotatedCamera, animated: true)
            } else {
                
                let regionRadius: CLLocationDistance = 250
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                
                myMap.setRegion(coordinateRegion, animated: true)
                
            }
            
        }
        
        
        if (speed1 >= 20.1168 && speed1 < 26.8224) { //45mph-60mph
        
            if #available(iOS 9.0, *) {
                let rotatedCamera = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 1800.0, pitch: 50.0, heading: heading1)
                myMap.setCamera(rotatedCamera, animated: true)
            } else {
                
                let regionRadius: CLLocationDistance = 800
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                
                myMap.setRegion(coordinateRegion, animated: true)
                
            }
            
        }
        
        if (speed1 >= 26.8224) { //>=60mph
            
            if #available(iOS 9.0, *) {
                let rotatedCamera = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 2200.0, pitch: 50.0, heading: heading1)
                myMap.setCamera(rotatedCamera, animated: true)
            } else {
                
                let regionRadius: CLLocationDistance = 1000
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                
                myMap.setRegion(coordinateRegion, animated: true)
                
            }
        }
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if addManually == "" {
            
        } else {
            //myMap.setUserTrackingMode(.FollowWithHeading, animated: true)
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
                
                if ((p.addressDictionary!["City"]) != nil) {
                    //city = p.locality!
                    city = p.addressDictionary!["City"]! as! String
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
                
                //self.rotateLabel(annotation)
                
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(overlay: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        
        return renderer
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        myLocations.append(locations[0] as CLLocation)
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        //let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        myMap.showsUserLocation = true
        //myMap.setRegion(region, animated: true)
        
        centerMapOnLocation(userLocation)
        
        
        if (myLocations.count > 1){
            
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            
            myMap.addOverlay(polyline)
            
        }
        
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
                } else {
                    subThoroughfare = ""
                }
                
                if ((p.thoroughfare) != nil) {
                    thoroughfare = p.thoroughfare!
                } else {
                    thoroughfare = ""
                }
                
                if ((p.postalCode) != nil) {
                    zip = p.postalCode!
                } else {
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
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                        
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
                    
                    if ((p.addressDictionary!["City"]) != nil) {
                        //city = p.locality!
                        city = p.addressDictionary!["City"]! as! String
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
                    
                    //self.rotateLabel(annotation)
                    
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
                
                if ((p.addressDictionary!["City"]) != nil) {
                    //city = p.locality!
                    city = p.addressDictionary!["City"]! as! String
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
                
                //self.rotateLabel(annotation)
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                //annotation.title = title
                
                //self.myMap.addAnnotation(annotation)
                //let myAnnotationAtIndex = 0
                //self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)

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
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    
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

