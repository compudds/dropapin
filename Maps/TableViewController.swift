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

var activePlace = 0

var places = [Dictionary<String,String>()]

var array:[String] = []

var addManually = String()


class TableViewController: UITableViewController {
    
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
            
        } else {
            
            print("Places: \(places)")
            print("Array: \(array)")
            
        }

    }
    
    func rememberData() {
        
        let storedToDoItems: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("array")
        
        if storedToDoItems!.count >= 0 {
        
            for (var i = 0; i < storedToDoItems!.count; i += 1) {
            
                places.append(["name":storedToDoItems![i]["name"] as! String,"lat":storedToDoItems![i]["lat"] as! String,"lon":storedToDoItems![i]["lon"] as! String])
                
            }
           
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        
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



