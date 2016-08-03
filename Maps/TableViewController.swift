//
//  TableViewController.swift
//  Maps
//
//  Created by Rob Percival on 11/08/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
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

var activePlace = 0

var places = [Dictionary<String,String>()]

var array:[String] = []

var addManually = String()


class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet  var tasksTable:UITableView!
    
    
    @IBOutlet var addAddress: UITextField!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = places[indexPath.row]["name"]
        cell.textLabel!.font = UIFont.systemFontOfSize(18.0)
        cell.textLabel!.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(tableView: (UITableView!), canEditRowAtIndexPath indexPath: (NSIndexPath!)) -> Bool {
        return true
    }
    
    override func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            places.removeAtIndex(indexPath.row)
            let arraySaved = places
            NSUserDefaults.standardUserDefaults().setObject(arraySaved, forKey: "array")
            NSUserDefaults.standardUserDefaults().synchronize()
            tasksTable.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if count == 0 {
            
            rememberData()
            places.removeAtIndex(0)
            
            print("Places: \(places)")
            print("Array: \(array)")
            print("Count: \(count)")
            
            
        } else {
            
            print("Places: \(places)")
            print("Array: \(array)")
            print("Ct: \(count)")
            
        }

    }
    
    func updateLocation() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
            
       
        let latitude:CLLocationDegrees = manager.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager.location!.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        
        
        let userLocation:CLLocation = locations[0] as CLLocation
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:{(placemarks, error) in
                
                if ((error) != nil)  {
                    
                    print("Error: \(error)")
                    print("Region: \(theRegion)")
                    
                } else {
                    
                    
                    
                    let p = CLPlacemark(placemark: (placemarks?[0])! as CLPlacemark)
                    
                    //var subThoroughfare:String
                    var thoroughfare:String
                    var zip:String
                    
                    if ((p.postalCode) != nil) {
                        //subThoroughfare = p.subThoroughfare!
                        thoroughfare = p.thoroughfare!
                        zip = p.postalCode!
                    } else {
                        //subThoroughfare = ""
                        thoroughfare = ""
                        zip = ""
                    }
                    
                    if (thoroughfare == "Long Cabin Way" && zip ==  "10504") {
                        
                        let alert = UIAlertController(title: "Gate Code 8153", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                            
                            alert.dismissViewControllerAnimated(true, completion: nil)
                            
                            
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            })
        
         manager.stopUpdatingLocation()
            
        }
    
    
    func rememberData() {
        
        var storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
        
        if (places == []) {
            
            places.append(["name":"39 Taconic Rd, New Castle, NY 10562 United States","lat":"41.1921242298942","lon":"-73.8126774877997"])
            storedToDoItems = ["name":"39 Taconic Rd, New Castle, NY 10562 United States","lat":"41.1921242298942","lon":"-73.8126774877997"]
            
        }
        
        if storedToDoItems!.count > 0 {
        
            for (var i = 0; i < storedToDoItems!.count; i += 1) {
            
                places.append(["name":storedToDoItems![i]["name"] as! String,"lat":storedToDoItems![i]["lat"] as! String,"lon":storedToDoItems![i]["lon"] as! String])
                
            }
           
        } else {
            
            places.append(["name":"39 Taconic Rd, New Castle, NY 10562 United States","lat":"41.1921242298942","lon":"-73.8126774877997"])
            storedToDoItems = ["name":"39 Taconic Rd, New Castle, NY 10562 United States","lat":"41.1921242298942","lon":"-73.8126774877997"]
        }
            
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        updateLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!)  {
        
        if segue.identifier == "addPlace" {
            
            activePlace = -1
            
            addManually = addAddress.text!
            
            
        }
        
    }
    
    override func tableView(tableView: (UITableView!), didSelectRowAtIndexPath indexPath: (NSIndexPath!)) {
        
        daddr = ""
        
        activePlace = indexPath.row
        
        let alert = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Map", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegueWithIdentifier("findPlace", sender: indexPath)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Walking Directions", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                daddr = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")!)
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                }
                
            } else {
                
               
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")!)
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=walking&mapmode=standard")
                }
                
               

            }
                
           
            
        }))
        
        alert.addAction(UIAlertAction(title: "Driving Directions", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            if(daddr == "") {
                
                let daddr1 = places[indexPath.row]["name"]!
                let newTitle = "\(daddr1)"
                daddr = newTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")
                
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")!)
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")
                }
                
            } else {
                
                
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")!)
                    
                } else {
                    NSLog("Can't use comgooglemaps://");
                    print("comgooglemaps://?saddr=&daddr=\(daddr)&directionsmode=driving&views=traffic&mapmode=standard")
                }
                

            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let itemToMove = places[fromIndexPath.row]
        places.removeAtIndex(fromIndexPath.row)
        places.insert(itemToMove, atIndex: toIndexPath.row)
        tasksTable.reloadData()
        let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
        
        NSUserDefaults().setObject(places, forKey: "array" )
        
        print("StoredItems: \(storedToDoItems)")
        
    }
   
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    
    
    
    
}



