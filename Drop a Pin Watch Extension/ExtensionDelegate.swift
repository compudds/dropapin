//
//  ExtensionDelegate.swift
//  Drop a Pin Watch Extension
//
//  Created by Eric Cook on 3/27/18.
//  Copyright © 2018 Better Search, LLC. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications


class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, URLSessionTaskDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
         
        if error == nil {
                   
               } else {
                   
                   print("")
                   print("Error in Session Activation.")
                   print("")
                   print("Error: \(error!)")
                   
               }
    }
    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        //WKExtension.shared().delegate = self
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("")
            print("Session active")
        
        }
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 60 * 1), userInfo: nil) { (error) in
            
            if error == nil {
                
                print("")
                print("Scheduled background refresh activated for 30 min.")
                print("")
                
                
            } else {
                
                print("")
                print("Error Scheduling background refresh.")
                print("")
                print("Error: \(error!)")
                
                
            }
            
            
        }
        
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //InterfaceController().reinstateBackgroundTask()
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        
    }
    
    // MARK: WKExtensionDelegate
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
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
                
                InterfaceController().scheduleURLSession()
                
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
         
         
         /*DispatchQueue.main.async() {
             
             self.crypto.setText("BTC: $\(BTC2)")
             
             self.crypto2.setText("XRP: $\(XRP2)")
             
             self.crypto3.setText("XMR: $\(XMR2)")
             
         }*/
         
     }
     
     @objc func prices() {
         
         getPrices()
         
         _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: false)
       
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
     
     @objc func scheduleURLSession() {
         
         prices()
         
         _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(notification), userInfo: nil, repeats: false)
         
         scheduleBackgroundRefresh()
         
     }
     
    
    
}
