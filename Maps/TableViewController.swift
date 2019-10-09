//
//  TableViewController.swift
//  Maps
//
//  Created by Eric Cook on 3/27/18.
//  Copyright © 2018 Better Search, LLC. All rights reserved.
//

//
//  TableViewController.swift
//  Maps
//
//  Created by Rob Percival on 11/08/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI
import WatchConnectivity
import Intents

var activePlace = 0

var places = [Dictionary<String,String>()]
var places2 = [Dictionary<String,String>()]
var places2Name = String()

var addManually = String()

var storedItems = UserDefaults.standard.object(forKey: "array") as? [Dictionary<String, String>]?
//var storedItemsArray = storedItems.object(forKey: "array") as? [Dictionary<String, String>]!

@available(iOS 9.3, *)
class TableViewController: UITableViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    let session = WCSession.default
    
    var iPathEmail = [String]()
    var iPathText = [String]()
    
    @IBOutlet  var tasksTable:UITableView!
    
    @IBOutlet var addAddress: UITextField!  //manually add place
    
    @IBOutlet var stopButtonTitle: UIBarButtonItem!
    
    @IBOutlet var editButtonTitle: UIBarButtonItem!
    
    @IBAction func addButton(_ sender: Any) {
        
        performSegue(withIdentifier: "addButtonToMap", sender: self)
        
    }
    
    
    
    @IBAction func stopButton(_ sender: Any) {
        
        self.tableView.isEditing = false
        
        stopButtonTitle.isEnabled = false
        
        editButtonTitle.isEnabled = true
        
        editButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        
        stopButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
    }
    
   @IBAction func editButton(_ sender: Any) {
        
        self.tableView.isEditing = true
    
        stopButtonTitle.isEnabled = true
    
        editButtonTitle.isEnabled = false
    
        editButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
    
        stopButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
    
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        
        refresh()
        
    }
    
    /*@IBAction func sendToWatchTapped(_ sender: Any) {
        
        if self.session.isPaired == true && self.session.isWatchAppInstalled {
            
            //self.session.sendMessage(["msg": "\(places2Name)"], replyHandler: nil, errorHandler: nil)
            self.session.sendMessage(["msg": "\(BTC2)\r\(XRP2)\r\(XMR2)"], replyHandler: nil, errorHandler: nil)
            print("Send to watch data: \(places2Name)")
        }
        
    }*/
    
    @objc func didReceiveWatchData(info: Notification) {
        
        let msg = info.userInfo!
        print("MSG: \(msg)")

        let string = msg["msg"]! as! String
        print("stringOfMsg: \(string)")
        
        let dict = [string]
       
        if let json3 = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if var content3 = String(data: json3, encoding: .utf8) {
                content3 = content3.replacingOccurrences(of: "[\"[", with: "{")
                content3 = content3.replacingOccurrences(of: "]\"]", with: "}")
                content3 = content3.replacingOccurrences(of: "\\", with: "")
                print("Content3: \(content3)")
                
                let content4 = String(content3)
                print("Content4: \(content4)")
                    
                struct Location : Codable {
                    let name: String
                    let lon: String
                    let lat: String
                }
                
                let jsonData = content4.data(using: .utf8)!
                let decoder = JSONDecoder()
                let addr = try! decoder.decode(Location.self, from: jsonData)
                
                let address = addr.name
                let lat  = addr.lat
                let lon = addr.lon
                
                places.append(["name":String(address),"lat":String(lat),"lon":String(lon)])
                
                print(places)
                
                UserDefaults.standard.set(places, forKey: "array" )
                
                UserDefaults.standard.synchronize()
                
                tasksTable.reloadData()
                
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        cell.textLabel!.text = places[indexPath.row]["name"]
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 18.0)
        cell.textLabel!.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: (UITableView?), canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: (UITableView?), commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //if (editingStyle == UITableViewCell.EditingStyle.delete) {
        if (editingStyle == .delete) {
            places.remove(at: indexPath.row)
            //let arraySaved = places
            UserDefaults.standard.set(places, forKey: "array")
            UserDefaults.standard.synchronize()
            tasksTable.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //session.delegate = self as? WCSessionDelegate
        //session.activate()
        
        stopButtonTitle.isEnabled = false
        
        self.navigationItem.leftBarButtonItems = [editButtonTitle, stopButtonTitle]
        editButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.6)
        stopButtonTitle.tintColor = UIColor.blue.withAlphaComponent(0.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveWatchData), name: NSNotification.Name(rawValue: "receivedWatchMessage"), object: nil)
        
        //getPrices()
        
        if count == 0 {
            
            print("Places: \(places)")
            print("Count: \(count)")
            
            rememberData()
            places.remove(at: 0)
            if let reload = tasksTable {
                
                reload.reloadData()
                
                refresh()
            }
            //tasksTable.reloadData()
            //refresh()
            
            
        } else {
            
            print("Places: \(places)")
            print("Ct: \(count)")
            if let reload = tasksTable {
                
                reload.reloadData()
                
                refresh()
            }
            
        }

    }
    
    /*func getPrices() {
        
        let coins = ["BTC","XRP","XMR"]
        
        UserDefaults.standard.removeObject(forKey: "BTC")
        
        UserDefaults.standard.removeObject(forKey: "XRP")
        
        UserDefaults.standard.removeObject(forKey: "XMR")
        
        for coin in coins {
            
            do {
                
                if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(coin)&tsyms=USD") {
                    
                    let data = try Data(contentsOf: url)
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let object = json as? [String: Double] {
                        
                        if let price = object["USD"] {
                            
                            //let price = object.first
                            
                            print(price)
                            
                            let coinPrice = "\(coin): $\(price)"
                            
                            print(coinPrice)
                            
                            UserDefaults.standard.set(price, forKey: coin)
                            
                            if coin == "BTC" {
                                
                                let BTC1 = UserDefaults.standard.double(forKey: "BTC")
                                
                                print(BTC1)
                                
                                BTC2 = String(BTC1)
                            }
                            
                            if coin == "XRP" {
                                
                                let XRP1 = UserDefaults.standard.double(forKey: "XRP")
                                
                                print(XRP1)
                                
                                XRP2 = String(XRP1)
                                
                            }
                            
                            if coin == "XMR" {
                                
                                let XMR1 = UserDefaults.standard.double(forKey: "XMR")
                                
                                print(XMR1)
                                
                                XMR2 = String(XMR1)
                                
                            }
                            
                        }
                        
                    } else {
                        print("JSON is invalid")
                    }
                } else {
                    print("Invalid URL")
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        if self.session.isPaired == true && self.session.isWatchAppInstalled {
            
            //self.session.sendMessage(["msg": "\(places2Name)"], replyHandler: nil, errorHandler: nil)
            self.session.sendMessage(["msg": "BTC: $\(BTC2)\rXRP: $\(XRP2)\rXMR: $\(XMR2)"], replyHandler: nil, errorHandler: nil)
            print("Send to watch data: BTC: $\(BTC2)\rXRP: $\(XRP2)\rXMR: $\(XMR2)")
        }
    }*/
    
    func refresh() {
        
        widget()
        
        if let reload = tasksTable {
            
            reload.reloadData()
        }
        
    }
    
    func updateLocation() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        //updateLocation()
        
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let _:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: theSpan)
        
        
        let userLocation:CLLocation = locations[0] as CLLocation
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:{(placemarks, error) in
                
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
                        //city = p.locality!
                        city = p.locality! //p.addressDictionary!["City"]! as! String
                    } else {
                        city = ""
                    }
                    
                    if ((p.postalCode) != nil) {
                        zip = p.postalCode!
                    } else {
                        zip = ""
                    }
                    
                    if ((p.country) != nil) {
                        country = p.country! //p.addressDictionary!["Country"]! as! String
                    } else {
                        country = ""
                    }

                    
                    var title = "\(subThoroughfare) \(thoroughfare), \(city), \(state) \(zip) \(country)"
                    
                    if title == "" {
                        
                        let date = NSDate()
                        
                        title = "Added \(date)"
                        
                    }
                    
                    if (thoroughfare == "Long Cabin Way" && zip ==  "10504") {
                    
                    //if (thoroughfare == "Taconic Rd" && zip ==  "10562") {
                        
                        let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }

                        
                    if (subThoroughfare >= "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                            
                        let alert = UIAlertController(title: "Pool Code 421", message: "", preferredStyle: UIAlertController.Style.alert)
                            
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                            alert.dismiss(animated: true, completion: nil)
                                
                                
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            })
        
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
        
        //refresh()
        
    }
    
    
    
    func rememberData() {
        //storedItems = [] //nil
        
        //if ((storedItems == nil) || (storedItems??.isEmpty)!)  {
        if (storedItems == nil)  {
            
            print("RemeberData = nil")
           
            places.append(["name":"39 Taconic Rd, New Castle, NY 10562 United States","lat":"41.1921242298942","lon":"-73.8126774877997"])
            places.append(["name":"572 Route 6, Mahopac, NY 10541 United States","lat":"41.3919059","lon":"-73.7259985"])
            places.append(["name":"4 Hopkins Rd, Armonk, NY 10504 United States","lat":"41.123988","lon":"-73.7201257"])
            places.append(["name":"7 Doral Dr, Manhasset, NY 11030 United States","lat":"40.7768413","lon":"-73.6757609"])
            places.append(["name":"63 Diamond Dr, Plainview, NY 11803 United States","lat":"40.7898387","lon":"-73.4785282"])
            places.append(["name":"1 Kristi Dr, Jericho, NY 11753 United States","lat":"40.79897918","lon":"-73.5356629"])
            
            UserDefaults.standard.set(places, forKey: "array" )
            UserDefaults.standard.synchronize()
            
        } else {
            
            print("RemeberData NOT nil")
            
            if let count = storedItems??.count {
                
                for i in 0..<count {
                    
                    places.append(storedItems!![i])
                }
                
            }

        }
        
        if let reload = tasksTable {
            
            reload.reloadData()
        }
        
        
        
        print("PlacesCount : \(places.count)")
        print("Places : \(places)")
        print("storedItems : \(String(describing: storedItems))")
            
        
    }
    
    func widget() {
        
        let defaults = UserDefaults(suiteName: "group.bettersearchllc.sharewidgetplace")
        let widgetPlace = defaults!.object(forKey: "place")
        
        if (widgetPlace == nil || widgetPlace as! [String:String] == [:] ) {
            
            print("widgetPlace is nil or blank.")
            
        } else {
            
            print("widgetPlace: ")
            print(widgetPlace!)
            if (widgetPlace as! [String:String] == [:]) {
                
                defaults!.removeObject(forKey: "place")
                defaults!.synchronize()
                
            }
            places.append(widgetPlace as! [String : String])
            UserDefaults.standard.set(places, forKey: "array" )
            UserDefaults.standard.synchronize()
            
            
            defaults!.removeObject(forKey: "place")
            defaults!.synchronize()
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        refresh()
       
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        
        tasksTable.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addButtonToMap" {
            
            activePlace = -1
            
            addManually = addAddress.text!
            
            
        }
        
    }
    
    override func tableView(_ tableView: (UITableView?), didSelectRowAt indexPath: IndexPath) {
        
        daddr = ""
        
        activePlace = indexPath.row
       
        places2Name = "\(places[indexPath.row]["name"]!)@\(places[indexPath.row]["lon"]!)@\(places[indexPath.row]["lat"]!)"
        
        places2Name = places2Name.trimmingCharacters(in: .whitespaces)
        
        print(places2Name)
        
        let alert = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Map", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "cellItemToMap", sender: indexPath)
            //self.performSegue(withIdentifier: "cellItemToMap", sender: self)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Walking Directions", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                //daddr = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                daddr = newTitle.replacingOccurrences(of: " ", with: "+")
                
                if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                    
                    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard") {
                        
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                            
                            print("Open Walking Directions: comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                        })
                        
                    }
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                }
                
            } else {
                
               
                if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                   
                    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard") {
                        
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                            
                            print("Open Walking Directions: comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                        })
                        
                    }
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                }
             
            }
           
            
        }))
        
        alert.addAction(UIAlertAction(title: "Driving Directions", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                daddr = newTitle.replacingOccurrences(of: " ", with: "%20")
                
                /*if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")!)
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")
                }*/
                
                if (UIApplication.shared.canOpenURL(NSURL(string:"waze://")! as URL)) {
                    
                    if let url = URL(string: "waze://?q=\(daddr)&navigate=yes") {
                       
                            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                                
                                print("Open Driving Directions: waze://?q=\(daddr)&navigate=yes")
                            })
                    
                    }
            
                    
                } else {
                    NSLog("Can't use Waze");
                    print("waze://?q=\(daddr)&navigate=yes")
                }
                
            } else {
                
                
                if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                   
                    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard") {
                        
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                            
                            print("Open Driving Directions: comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")
                        })
                        
                    }
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")
                }
                

            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Text Location", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                daddr = newTitle.replacingOccurrences(of: " ", with: "+")
                
                self.sendText()
                
            } else {
                
                self.sendText()
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Email Location", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                daddr = newTitle.replacingOccurrences(of: " ", with: "+")
                
                self.sendEmail()
                
            } else {
                
                self.sendEmail()
                
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Send To Watch", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
                
                let message = ["msg": "\(places2Name)"]
                WCSession.default.sendMessage(message, replyHandler: nil)
                
            }
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)

        
        
    }
    
    func sendText() {
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.subject = "Here is my location!";
        messageVC.body =  "Google Maps: \n https://www.google.com/maps/place/" + daddr + "\n\n Waze: \n http://waze.to/?q=" + daddr + "\n\n Apple Maps: \n http://maps.apple.com/maps?saddr=&daddr=" + daddr
        messageVC.recipients = iPathText
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
        
    }
    
    func sendEmail() {
        
        let toRecipents = iPathEmail  //iPathEmail
        //var toRecipents: [String] = iPathEmail as [String]
        print(toRecipents)
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setSubject("Here is my location!")
        
        mc.setMessageBody("<p>Google Maps: </p><p> https://www.google.com/maps/place/" + daddr + "</p><p> Waze: </p><p> http://waze.to/?q=" + daddr + "</p><p> Apple Maps: </p><p> http://maps.apple.com/maps?saddr=&daddr=" + daddr + "</p>", isHTML: true)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
        
    }
        
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
        
        tasksTable.reloadData()
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
           print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
           print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        tasksTable.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        let itemToMove = places[fromIndexPath.row]
        places.remove(at: fromIndexPath.row)
        places.insert(itemToMove, at: toIndexPath.row)
        tasksTable.reloadData()
        UserDefaults.standard.set(places, forKey: "array" )
        UserDefaults.standard.synchronize()
        
        
    }
    
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}




