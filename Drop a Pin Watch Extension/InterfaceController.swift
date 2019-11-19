//
//  InterfaceController.swift
//  Drop a Pin Watch Extension
//
//  Created by Eric Cook on 3/27/18.
//  Copyright © 2018 Better Search, LLC. All rights reserved.
///

import WatchKit
import Foundation
import UserNotifications
import UIKit
import WatchConnectivity
import CoreLocation
import MapKit
import Intents


var manager2 = CLLocationManager()
var myLocations2: [CLLocation] = []

var daddr2 = String()

var places3 = [Dictionary<String,String>()]
var newPlace = String()
var newPlace1 = Double()
var newPlace2 = Double()

var BTC = String()
var XMR = String()
var XRP = String()

var BTC1 = Double()
var XMR1 = Double()
var XRP1 = Double()

/*var BTC1 = String()
var XMR1 = String()
var XRP1 = String()*/

var lastLocationText = String()
var updatedTime = Int()


class InterfaceController: WKInterfaceController, WKExtensionDelegate,  CLLocationManagerDelegate, URLSessionTaskDelegate {
    
    var iPathEmail = [String]()
    var iPathText = [String]()
    var pressedCount = 0
    
    var currentLocation = CLLocation()
    
    
    @IBOutlet var map: WKInterfaceMap!
    @IBOutlet var locationText: WKInterfaceLabel!
    @IBOutlet var crypto: WKInterfaceLabel!
    @IBOutlet var crypto2: WKInterfaceLabel!
    @IBOutlet var crypto3: WKInterfaceLabel!
    
    var timer : Timer?
    
    //let session = WCSession.default
    
    /*func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if error == nil {
            
        } else {
            
            print("")
            print("Error in Session Activation.")
            print("")
            print("Error: \(error!)")
            
        }
        
    }*/
    
    @IBAction func clear() {
        
        //tap-tap haptic tap
        WKInterfaceDevice.current().play(.directionDown)
        
        places3 = []
        
        locationText.setText("")
        
        lastLocationText = ""
        
        map.setAlpha(0)
    }
    
   
    @IBAction func updatePrice() {
        
        //tap-tap haptic tap
        WKInterfaceDevice.current().play(.notification)
        
        prices()
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(notification), userInfo: nil, repeats: false)
       
        
    }
    
    @objc func doNothing() {
        
        print("")
        print("This does nothing but wait 4 seconds for things to run!!!!")
        print("")
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //WKExtension.shared().delegate = self
        
       /*if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("")
            print("Session active")
        
        }*/
        
       NotificationCenter.default.addObserver(self, selector: #selector(didReceivePhoneData), name: NSNotification.Name(rawValue: "receivedPhoneData"), object: nil)
        
       //NotificationCenter.default.addObserver(self, selector: #selector(didReceiveExtensionData), name: NSNotification.Name(rawValue: "receivedExtensionData"), object: nil)
        
        
        //scheduleURLSession()
        
        places3 = []
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        manager2.delegate = self
        manager2.desiredAccuracy = kCLLocationAccuracyBest
        manager2.requestLocation()
        manager2.requestWhenInUseAuthorization()
        manager2.startUpdatingLocation()
        
        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(doNothing), userInfo: nil, repeats: false)
        
         scheduleURLSession()
        
    }
    
    override func didAppear() {
        
    }
    
    @objc func reinstateBackgroundTask() {
        
        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(doNothing), userInfo: nil, repeats: false)
        
        scheduleURLSession()
    }
    
    
    @IBAction func sendText() {
        
        //tap-tap haptic tap
        WKInterfaceDevice.current().play(.directionDown)
        
        if lastLocationText == "" || lastLocationText.isEmpty {
            
            self.locationText.setText("Could not get your location. Please try again.")
            
        } else {
            
            self.locationText.setText("Sent to iPhone:\r\(lastLocationText)")
            
            let messageBody = "My location is \(lastLocationText)."  // and the Apple Maps link is: \r http://maps.apple.com/maps?saddr=&daddr=\(daddr)"
            
            let urlSafeBody = messageBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            WKExtension.shared().openSystemURL(URL(string: "sms:&body=\(urlSafeBody)")!)
        }
        
        
    }
    
    @IBAction func makePhoneCall() {
        
        //tap-tap haptic tap
        WKInterfaceDevice.current().play(.directionDown)
        
        WKExtension.shared().openSystemURL(URL(string: "tel:19149071832")!)
        
    }
    
    func sendLocationToIphone() { //Drop A Pin Button
        
        WKInterfaceDevice.current().play(.directionDown)
        
        if (places3.isEmpty || places3 == [[:]] ) {
            
            self.locationText.setText("Could not get your location. Please try again.")
            
        } else {
            
            let message = ["msg": "\(places3[0])"]
            
            //places.append(["name":String(address[0]),"lat":String(lat[0]),"lon":String(lon[0])])
            
            print(message)
            
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            self.locationText.setText("Sent to iPhone:\r\(lastLocationText)")
            
            print(lastLocationText)
            
            places3 = []
            
        }
        
    }
    
    @objc func didReceivePhoneData(info: Notification) {
        
        let msg = info.userInfo!
        print(msg)
        let fullMsg = msg["msg"] as? String
        let fullMsgArr = fullMsg?.components(separatedBy: "@")
        
        let loc = fullMsgArr![0].trimmingCharacters(in: .whitespaces)
        let lon = Double(fullMsgArr![1].trimmingCharacters(in: .whitespaces))
        let lat = Double(fullMsgArr![2].trimmingCharacters(in: .whitespaces))
        
        DispatchQueue.main.async() {
            
             self.locationText.setText(loc)  
        }
        
        map.setAlpha(1)
        
        let mapLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
       
        let coordinateSpan: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1)
        
        map.addAnnotation(mapLocation, with: .red)
        map.setRegion(MKCoordinateRegion.init(center: mapLocation, span: coordinateSpan))
        
    }
    
    @objc func didReceiveExtensionData(info: Notification) {
        
        let msg = info.userInfo!
        print(msg)
        let fullMsg = msg["msg1"] as? String
        let fullMsgArr = fullMsg?.components(separatedBy: " ")
        
        let bit = fullMsgArr![0]  //.trimmingCharacters(in: .whitespaces)
        let rip = fullMsgArr![1]  //.trimmingCharacters(in: .whitespaces)
        let mon = fullMsgArr![2]  //.trimmingCharacters(in: .whitespaces)
        
        /*BTC2 = bit
        
        XRP2 = rip
        
        XMR2 = mon
        
        DispatchQueue.main.async() {
            
            self.crypto.setText("BTC: $\(BTC2)")
            
            self.crypto2.setText("XRP: $\(XRP2)")
            
            self.crypto3.setText("XMR: $\(XMR2) Ext")
        }*/
        
        prices()
        
        notification()
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let msg = message as! [String : String]
        
        for (key, value) in msg {
            
            print("\(key)")
            print("\(value)")
            
            if key == "msg" {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedPhoneData"), object: self, userInfo: message)
                
            } else {
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedExtensionData"), object: self, userInfo: message)
            }
        }
        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        print("")
        print("View Controller no longer active.")
        print("")
        print("Waiting for backgroundTask to re-activate...")
    }
    
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        let activity = NSUserActivity(activityType: "com.bettersearchllc.Maps.dropPin")
        activity.title = "Drop a Pin"
        activity.userInfo = ["Message" : "Here is my location"]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("xyz")
        //view.userActivity = activity
        activity.becomeCurrent()
        
        
        findLocation()
        
        //tap-tap haptic tap
        WKInterfaceDevice.current().play(.directionDown)
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0
        {
            return
        }
        currentLocation = locations.first!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail to load location")
        print(error.localizedDescription)
    }
    
    @objc func findLocation() {
        
        var latitude = CLLocationDegrees()
        var longitude = CLLocationDegrees()
        
        latitude = currentLocation.coordinate.latitude  //manager2.location!.coordinate.latitude
        longitude = currentLocation.coordinate.longitude  //manager2.location!.coordinate.longitude
            
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
                
                
                let title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                let newTitle = "\(subThoroughfare),+\(thoroughfare),+\(city),+\(state)+\(zip)+\(country)"
                let title1 = newTitle.replacingOccurrences(of: " ", with: "+")
                
                self.locationText.setText("\(title)")
                lastLocationText = title
                newPlace = title
                newPlace1 = latitude
                newPlace2 = longitude
                
                //if (title != " , ,   ") {
                    
                    let defaults = UserDefaults(suiteName: "group.bettersearchllc.shareWatchData")
                    let defaultValue = ["lat":"\(latitude)","lon":"\(longitude)","name":"\(title)"]
                    defaults!.register(defaults: defaultValue)
                    defaults!.set(defaultValue, forKey: "place")
                    defaults!.synchronize()
                    
                    places3.append(defaultValue)
                    
                    //UserDefaults.standard.set(places3, forKey: "array" )
                    
                    //UserDefaults.standard.synchronize()
                    
                    //print(defaults!)
                    print("Places:\(places3)")
                    
                    daddr2 = "\(title1)"
                
                //let loc = "\(title)"
                let lon = longitude
                let lat = latitude
                
                    
                self.map.setAlpha(1)
                
                let mapLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                
                let coordinateSpan: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1)
                
                self.map.addAnnotation(mapLocation, with: .red)
                self.map.setRegion(MKCoordinateRegion.init(center: mapLocation, span: coordinateSpan))
                
                self.sendLocationToIphone()
                
               
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                    self.locationText.setText("Gate Code 8153.")
                    
                    //tap-tap haptic tap
                    WKInterfaceDevice.current().play(.notification)
                    
                }
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                    self.locationText.setText("Pool Code 421.")
                    
                    //tap-tap haptic tap
                    WKInterfaceDevice.current().play(.notification)
                    
                }
            }
            
            
        })
        
    }
    
    func getPrices() {
        
        let coins = ["BTC","XRP","XMR"]
        
        UserDefaults.standard.removeObject(forKey: "BTC")
        
        UserDefaults.standard.removeObject(forKey: "XRP")
        
        UserDefaults.standard.removeObject(forKey: "XMR")
        
        for coin in coins {
            
            var request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(coin)&tsyms=USD")!)
            
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            //let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(coin)&tsyms=USD")
                
            
            //let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    let json = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    
                    if let object = json as? [String: Double] {
                        
                        if let price = object["USD"] {
                            
                            let coinPrice = "\(coin): $\(price)"
                            
                            print(coinPrice)
                            
                            UserDefaults.standard.set(price, forKey: coin)
                            
                            if coin == "BTC" {
                                
                                BTC1 = UserDefaults.standard.double(forKey: "BTC")
                               
                            }
                            
                            if coin == "XRP" {
                                
                                XRP1 = UserDefaults.standard.double(forKey: "XRP")
                                
                            }
                            
                            if coin == "XMR" {
                                
                                XMR1 = UserDefaults.standard.double(forKey: "XMR")
                                
                            }
                            
                       }
                        
                    }
                        
                } catch let parsingError {
                    
                    print("Error", parsingError)
                    
                }
            }
                
            .resume()
          
        }
        
    }
    
    @objc func updateScreen() {
        
        BTC2 = String(format: "%.2f", BTC1)
        
        XRP2 = String(format: "%.4f", XRP1)
        
        XMR2 = String(format: "%.2f", XMR1)
        
        
        DispatchQueue.main.async() {
            
            self.crypto.setText("BTC: $\(BTC2)")
            
            self.crypto2.setText("XRP: $\(XRP2)")
            
            self.crypto3.setText("XMR: $\(XMR2)")
            
        }
        
    }
    
    @objc func prices() {
        
        getPrices()
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(notification), userInfo: nil, repeats: false)
        
    }
    
    func updateCurrentTime() {
        
        updatedTime = 0
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "Hmm"
        
        updatedTime = Int(formatter.string(from: currentDateTime))!
        
    }
    
    @objc func updateComplication() {
        
         //Notification
         let content = UNMutableNotificationContent()
         content.title = "Crypto Updated"
         content.subtitle = ""
         content.body = "BTC: $\(BTC2)\rXRP: $\(XRP2)\rXMR: $\(XMR2)"
         content.badge = 1
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
         
         let identifier = self.stringWithUUID()
         let request = UNNotificationRequest.init(
         identifier: identifier,
         content: content,
         trigger: trigger
         )
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        //Update Complication
        let server = CLKComplicationServer.sharedInstance()
        for complication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
        
        self.updateCurrentTime()
        
        print("Time: \(updatedTime)")
        
        
        
    }
    
    @objc func notification() {
        
        print("")
        
        print("Prices updated, BTC: $\(BTC2), XRP: $\(XRP2) and XMR: $\(XMR2)")
        
        print("")
        
        print("Complication updated.")
        
        print("")
        
        updateComplication()
        
        updateScreen()
        
        if (updatedTime >= 730 && updatedTime <= 2300) {
            
            //tap-tap haptic tap acivated between 7:30am - 11:00pm
            WKInterfaceDevice.current().play(.notification)
            
        }
        
    }

    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        
        return formatter
    }()
    
    
    // MARK: WKExtensionDelegate
    /*func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task : WKRefreshBackgroundTask in backgroundTasks {
            print("Received background task: ", task)
            print("")
            
            // only handle these while running in the background
            if (WKExtension.shared().applicationState == .background) {
                if task is WKApplicationRefreshBackgroundTask {
                    // this task is completed below, our app will then suspend while the download session runs
                    print("Application task received, start URL session")
                    print("")
                    
                    scheduleURLSession()
                    
                    
                }
            }
            else if let urlSessionTask = task as? WKURLSessionRefreshBackgroundTask {
                
                let backgroundConfigObject = URLSessionConfiguration.background(withIdentifier: urlSessionTask.sessionIdentifier)
                
                let _ = URLSession(configuration: backgroundConfigObject, delegate: self, delegateQueue: nil)
                
                scheduleURLSession()
                
                urlSessionTask.setTaskCompletedWithSnapshot(true)
             
                print("urlSessionTask completed.")
            }
            else if let snapshotTask = task as? WKSnapshotRefreshBackgroundTask {
                //scheduleSnapshot()
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
                print("SnapshotRefresh Completed.")
            }
            // make sure to complete all tasks, even ones you don't handle
            //task.setTaskCompleted()
            task.setTaskCompletedWithSnapshot(true)
            
            print("")
            print("Background task completed.")
            print("")
            
        }
        
    }
    
    func scheduleBackgroundRefresh() {
        // Initiate a background refresh for 30 minutes from now.
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 60 * 30), userInfo: nil) { (error) in
            
            if error == nil {
                
                print("")
                print("Scheduled background refresh for 30 min.")
                print("")
                
            } else {
                
                print("")
                print("Error Scheduling background refresh.")
                print("")
                print("Error: \(error!)")
                
                
            }
            
            
        }
        
    }
    
    func applicationDidEnterBackground() {
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: Date(), userInfo: nil) { (_) in
            print("")
            print("Background snapshot refresh completed.")
            print("")
            
        }
    
    }
   
    
    let userInfo = ["reason" : "background update snapshot"] as NSDictionary
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        print("")
        print("Session data received.")
        print("")
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if ((error) != nil)  {
            
            print("URLSessionTask Error: \(error!)")
            
        } else {
            
            print("")
            print("URLSessionTask completed without errors.")
            print("")
            
        }
    }*/
    
    @objc func scheduleURLSession() {
        
        prices()
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(notification), userInfo: nil, repeats: false)
        
        //scheduleBackgroundRefresh()
        
    }
    
}


    



