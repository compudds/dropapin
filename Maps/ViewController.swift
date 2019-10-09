//
//  ViewController.swift
//  Learning Maps
//
//  Created by Eric Cook on 3/27/18.
//  Copyright © 2018 Better Search, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import WatchConnectivity
import Intents
//import SystemConfiguration

var manager:CLLocationManager!
var myLocations: [CLLocation] = []
var lastLocation = [CLLocationCoordinate2D()]
var startLocal: CLLocation!
var lastLocal: CLLocation!
var startDate: Date!
var traveledDistance: Double = 0

var count = 0
var saddr = String()
var daddr = String()


@available(iOS 9.3, *)
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var locationFromWatch: UILabel!
    @IBOutlet var latitude : UILabel!
    @IBOutlet var longitude : UILabel!
    @IBOutlet var address : UILabel!
    @IBOutlet var altitude : UILabel!
    @IBOutlet var speed : UILabel!
    @IBOutlet var heading : UILabel!

    let annotation = MKPointAnnotation()
    
    @IBAction func clickButton(_ sender: Any) {
        
        self.saveButtonTitle.isEnabled = true
        
        saveButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        
        self.clickButtonTitle.isEnabled = false
        
        clickButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        self.clearButtonTitle.isEnabled = false
        
        clearButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        DispatchQueue.main.async {
            
            self.takeScreenshot(true)
            
            self.performSegue(withIdentifier: "mapToPlaces", sender: self)
            
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            self.performSegue(withIdentifier: "mapToPlaces", sender: self)
            
        }*/
        
    }
    
    @IBOutlet var clearButtonTitle: UIBarButtonItem!
    
    @IBAction func clearButton(_ sender: Any) {
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        self.clearButtonTitle.isEnabled = false
        
        clearButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        self.saveButtonTitle.isEnabled = true
        
        saveButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        
        self.clickButtonTitle.isEnabled = false
        
        clickButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        
    }
    
    /*func sendPriceUpdateToWatch() {
        
        if (WCSession.default.isReachable) {
            
            let message = ["msg1": "\(BTC2) \(XRP2) \(XMR2)"]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            print("Sent data to Apple Watch BTC:$ \(BTC2) XRP: $\(XRP2) XMR: $\(XMR2)")
            
        }
        
        
    }*/
    
    @IBOutlet var clickButtonTitle: UIBarButtonItem!
    
    @IBOutlet var saveButtonTitle: UIBarButtonItem!
    
    @IBAction func saveButton(_ sender: Any) {
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        
        self.clearButtonTitle.isEnabled = true
        
        clearButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        
        self.saveButtonTitle.isEnabled = false
        
        saveButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        self.clickButtonTitle.isEnabled = true
        
        clickButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        
        let location = lastLocation[lastLocation.endIndex - 1]
        
        let regionRadius: CLLocationDistance = traveledDistance  //1500
        
        let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius * 1.5, longitudinalMeters: regionRadius * 1.5)
        
        self.myMap.setRegion(coordinateRegion, animated: true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        performSegue(withIdentifier: "mapToPlaces", sender: self)
        
    }
    
    func takeScreenshot(_ shouldSave: Bool) -> UIImage? {
        
        if shouldSave == true {
            
            var screenshotImage :UIImage?
            
            let layer = UIApplication.shared.keyWindow!.layer
            
            let scale = UIScreen.main.scale
            
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            
            guard let context = UIGraphicsGetCurrentContext() else {return nil}
            
            layer.render(in:context)
            
            screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            if let image = screenshotImage, shouldSave {
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            return screenshotImage
        
        } else {
            
            return nil
        }
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.clickButtonTitle.isEnabled = false
        
        clickButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        clearButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        
        myMap.delegate = self
        myMap.mapType = .standard
        myMap.showsTraffic = true
        myMap.showsPointsOfInterest = true
        
        count = count + 1
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if activePlace == -1  {
            
            findLocation()
            
        } else {
            
            let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
            
            let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            let latitude:CLLocationDegrees = lat
            
            let longitude:CLLocationDegrees = lon
            
            let latDelta:CLLocationDegrees = 0.01
            
            let lonDelta:CLLocationDegrees = 0.01
            
            let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: span)
            
            myMap.setRegion(region, animated: true)
            
            myMap.showsUserLocation = true
            
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 0.35
        
        myMap.addGestureRecognizer(uilpgr)
        
    }
    
    @IBAction func findMe(_ sender: AnyObject) {   //Track Button
        
        track()
        
    }
    
    
    func track() {
        
        myMap.removeAnnotation(annotation)
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        
        //let latDelta:CLLocationDegrees = 0.01
        //let longDelta:CLLocationDegrees = 0.01
        //let _:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        lastLocation = [CLLocationCoordinate2DMake(latitude, longitude)]
        
        /*myMap.mapType = MKMapType.standard
        myMap.showsTraffic = true
        myMap.showsPointsOfInterest = true*/
        
        /*let newCamera = MKMapCamera()
        newCamera.heading = 90.0
        myMap.setCamera(newCamera, animated: true)*/
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(String(describing: error))")
                
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
                
                if ((p.country) != nil) {
                    country = p.country!
                } else {
                    country = ""
                }
                
                
                self.annotation.coordinate = myLocation
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.replacingOccurrences(of:" ", with: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                /*self.annotation.title = title
                
                self.myMap.addAnnotation(annotation)
                let myAnnotationAtIndex = 0
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)*/
                
                
                var match = "no"
                
                for i in 0..<places.count {
                    
                    if (places[i]["name"]! == "\(title)") {
                        
                        match = "yes"
                        
                    }
                    
                }
                
                if match == "no" {
                    
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    UserDefaults.standard.set(places, forKey: "array" )
                    
                    UserDefaults.standard.synchronize()
                    
                }
                
                daddr = "\(title1)"
                print(daddr)
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if ((subThoroughfare >= "5" && subThoroughfare <= "20" ) && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
            
        })
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    var heading1 = CLLocationDirection()
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let speedMph = Int(speed2 * 2.23694)
        
        let nhf = CGFloat(newHeading.magneticHeading)
        
        heading1 = newHeading.magneticHeading
        
        print("")
        print("New Heading: \(newHeading.magneticHeading)\nSpeed: \(speedMph)\nHeading1: \(heading1)")
        
        
        if (speedMph <= 0) {
            
            speed.text = "0"
            
        }
        
        if (speedMph >= 70) {
            
            speed.textColor = UIColor.red
            
        } else {
            
            speed.textColor = UIColor.blue
            
        }
        
        //North
        if (nhf >= CGFloat(337.5000) && nhf < CGFloat(360.0000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "North"
            
           
        }
        
        if (nhf >= CGFloat(0.0000) && nhf < CGFloat(22.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "North"
            
        }
        
        //NE
        if (nhf >= CGFloat(22.5000) && nhf < CGFloat(67.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "NE"
           
        }
        //East
        if (nhf >= CGFloat(67.5000) && nhf < CGFloat(112.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "East"
           
        }
        //SE
        if (nhf >= CGFloat(112.5000) && nhf < CGFloat(157.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "SE"
           
        }
        //South
        if (nhf >= CGFloat(157.5000) && nhf < CGFloat(202.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "South"
            
        }
        //SW
        if (nhf >= CGFloat(202.5000) && nhf < CGFloat(247.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "SW"
            
        }
        //West
        if (nhf >= CGFloat(247.5000) && nhf < CGFloat(292.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "West"
            
        }
        //NW
        if (nhf >= CGFloat(292.5000) && nhf < CGFloat(337.5000)) {
            
            speed.text = "\(speedMph)"
            heading.text = "NW"
            
        }
        
    }
    
    var speed2 = CLLocationSpeed()
    
    func centerMapOnLocation(location: CLLocation) {
        
        var speed1: CLLocationSpeed = CLLocationSpeed()
        speed1 = location.speed
        speed2 = speed1
        print("")
        print("Speed: \(speed1)\nHeading: \(heading1)")
        
        if (speed1 <= 0.0000) { //0mph
            
            /*let camera = MKMapCamera()
            camera.centerCoordinate = myMap.centerCoordinate
            camera.altitude = 500.0
            camera.pitch = 50.0*/
            
            let rotatedCamera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 250.0, pitch: 50.0, heading: heading1)
            
            myMap.setCamera(rotatedCamera, animated: true)
            
        }
        
        if (speed1 > 0.0000 && speed1 < 8.9408) { //>0-20mph
            
            let rotatedCamera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 500.0, pitch: 50.0, heading: heading1)
            
            myMap.setCamera(rotatedCamera, animated: true)
            
        }
        
        if (speed1 > 8.9408 && speed1 < 20.1168) { //20-45mph
           
            let rotatedCamera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 800.0, pitch: 50.0, heading: heading1)
            
            myMap.setCamera(rotatedCamera, animated: true)
            
        }
        
        if (speed1 >= 20.1168 && speed1 < 26.8224) { //45mph-60mph
        
            let rotatedCamera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 1500.0, pitch: 50.0, heading: heading1)
            
            myMap.setCamera(rotatedCamera, animated: true)
            
        }
      
        if (speed1 >= 26.8224) { //>=60mph
            
            let rotatedCamera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 2200.0, pitch: 50.0, heading: heading1)
            
            myMap.setCamera(rotatedCamera, animated: true)
            
        } /*else {
                
                let regionRadius: CLLocationDistance = 1100
                
                let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
                
                myMap.setRegion(coordinateRegion, animated: true)
                
        }*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if addManually == "" {
            
        } else {
            
            manualLocation()
            
        }
        
      
    }
    
    
    @objc func action(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
        
            let touchPoint = gestureRecognizer.location(in: self.myMap)
        
            let newCoordinate = myMap.convert(touchPoint, toCoordinateFrom: self.myMap)
        
        let loc = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
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
                    country = p.country!  //addressDictionary!["Country"]! as! String
                } else {
                    country = ""
                }

                var myAnnotationAtIndex = 0
                
                //let annotation = MKPointAnnotation()
                
                self.annotation.coordinate = newCoordinate
                
                //self.rotateLabel(annotation)
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.replacingOccurrences(of:" ", with: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                self.annotation.title = title
                
                self.myMap.addAnnotation(self.annotation)
                
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)
                
                places.append(["name":"\(title)","lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                UserDefaults.standard.set(places, forKey: "array" )
                
                UserDefaults.standard.synchronize()
                
                myAnnotationAtIndex = myAnnotationAtIndex + 1
                
                daddr = "\(title1)"
                
            }
            
            })
            
            
        }

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if count == 0 {
            
            places.remove(at: 0)
            
        } else {
            
            
        }

        
    }
    
    var polyline = MKPolyline()
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(overlay: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
        
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        myLocations.append(locations[0] as CLLocation)
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        myMap.showsUserLocation = true
        
        centerMapOnLocation(location: userLocation)
        
        //Get total distance traveled
        if startDate == nil {
            
            startDate = Date()
            
        } else {
            
            print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
        }
        
        if startLocal == nil {
            
            startLocal = locations.first
           
        } else if let location = locations.last {
            
            traveledDistance += lastLocal.distance(from: location)
            
            print("Traveled Distance:",  traveledDistance)
            
            print("Straight Distance:", startLocal.distance(from: locations.last!))
            
        }
        
        lastLocal = locations.last
        
        if (myLocations.count > 1){
            
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            
            polyline = MKPolyline(coordinates: &a, count: a.count)
            polyline.title = "Polyline"
            
            myMap.addOverlay(polyline)
            
        }
        
        //_ = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(ViewController.updatePlacemark), userInfo: nil, repeats: true)
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  {
                
                print("Error: \(String(describing: error))")
                
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
                
               // self.address.text =  "\(subThoroughfare) \(p.thoroughfare) \n \(p.subLocality) \n \(p.subAdministrativeArea) \n \(p.postalCode) \(p.country)"
                self.address.text =  "\(subThoroughfare) \(String(describing: p.thoroughfare)) \n \(String(describing: p.subLocality)) \n \(String(describing: p.subAdministrativeArea)) \n \(String(describing: p.postalCode)) \(String(describing: p.country))"
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
        })
        
        
        
        saddr = "\(latitude),\(longitude)"
        print("")
        print("Source Address: \(saddr)")
        
    }
    
    func clear() {
        
        for overlay in myMap.overlays {
            if (overlay.title == "Polyline") {
                myMap.removeOverlay(overlay)
            }
        }
       myMap.removeAnnotation(annotation)
        
    }
    
    func manualLocation() {
        
        if addManually != "" {
            
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            let theSpan:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
            let address = addManually
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error!)
                }
                if let p = placemarks?.first {
                    
                    let coordinates:CLLocationCoordinate2D = p.location!.coordinate
                    print(coordinates)
                    
                    let latitude:CLLocationDegrees = coordinates.latitude
                    let longitude:CLLocationDegrees = coordinates.longitude
                    
                    let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let theRegion:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: theSpan)
                    self.myMap.setRegion(theRegion, animated: true)
                    self.myMap.mapType = MKMapType.standard

                    
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

                    
                    self.annotation.coordinate = myLocation
                    
                    let title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                    
                    self.annotation.title = title
                    
                    self.myMap.addAnnotation(self.annotation)
                    let myAnnotationAtIndex = 0
                    self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)
                    
                   
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    UserDefaults.standard.set(places, forKey: "array" )
                    
                    UserDefaults.standard.synchronize()
                   
                    }
            })
            
            
          addManually = ""
            
            
        } else {
            
            
            
        }
        
    }
    
    func findLocation() {
        
        //shows pin on map with title = current location and adds to places table
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let theRegion:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: theSpan)
        myMap.setRegion(theRegion, animated: true)
        //myMap.mapType = MKMapType.standard
        //myMap.showsTraffic = true
        //myMap.showsPointsOfInterest = true
        
        
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

                
                
                self.annotation.coordinate = myLocation
                
                //self.rotateLabel(annotation)
                
                var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.replacingOccurrences(of: " ", with: "+")
                
                if title == "" {
                    
                    let date = NSDate()
                    
                    title = "Added \(date)"
                    
                }
                
                self.annotation.title = title
                
                self.myMap.addAnnotation(self.annotation)
                let myAnnotationAtIndex = 0
                self.myMap.selectAnnotation(self.myMap.annotations[myAnnotationAtIndex], animated: true)

                var match = "no"
                
                
                for i in 0 ..< places.count {
                    
                    if (places[i]["name"]! == "\(title)") {
                        
                        match = "yes"
                        
                    }
                   
                }
                
                if match == "no" {
                    
                    places.append(["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"])
                    
                    UserDefaults.standard.set(places, forKey: "array" )
                    
                    UserDefaults.standard.synchronize()
                    
                }

                daddr = "\(title1)"
                print("\(title1)")
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
            
        })

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


