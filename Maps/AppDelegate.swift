//
//  AppDelegate.swift
//  Maps
//
//  Created by Rob Percival on 10/07/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

/*var BTC = String()
var XMR = String()
var XRP = String()

var BTC1 = String()
var XMR1 = String()
var XRP1 = String()*/


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, URLSessionDelegate {
    
    @available(iOS 9.3, *)
     func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
     
     }
     
     @available(iOS 9.0, *)
     func sessionDidBecomeInactive(_ session: WCSession) {
     
     }
     
     @available(iOS 9.0, *)
     func sessionDidDeactivate(_ session: WCSession) {
     
     }
    
    var window: UIWindow?
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //application.setMinimumBackgroundFetchInterval(1800)  //every 30 min
        
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
              let session = WCSession.default
              session.delegate = self
              session.activate()
                
            }
        }
        
        
        application.setMinimumBackgroundFetchInterval(1800)
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                                title: "Crypto Prices Updated!",
                                                options: .foreground)  //UNNotificationActionOptions(rawValue: 0))
        let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION",
                                                title: "Decline",
                                                options: .foreground) //UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let mainCategory =
            UNNotificationCategory(identifier: "updateCategory",
                                   actions: [acceptAction, cancelAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        // Register the notification type.
        //let notificationCenter = UNUserNotificationCenter.current()
        //notificationCenter.setNotificationCategories([mainCategory])
        
        // Register the categories with the notification center
        let categories: Set<UNNotificationCategory> = [mainCategory]
        UNUserNotificationCenter.current().setNotificationCategories(categories)
        
        // Request user authentication for displaying notifications and register for push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { registered, _ in
            guard registered else {
                print ("Failed to request notification authorization")
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.appfish.Maps.addPin" {
            
            
        }
    }
    
    @available(iOS 9.0, *)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedWatchMessage"), object: self, userInfo: message)
        
    }
    
    @available(iOS 9.0, *)
    private func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if (applicationContext["scheduleLocalNotification"] as? Bool) != nil {
            
            let content = UNMutableNotificationContent()
            content.title = (applicationContext["alertTitle"] as? String)!
            content.body = (applicationContext["alertBody"] as? String)!
            content.sound = applicationContext["soundName"] as? UNNotificationSound
            //content.userInfo = []
            content.categoryIdentifier = "updateCategory"
            
            // Configure the trigger for a 7am wakeup.
            //var dateInfo = DateComponents()
            //dateInfo.hour = 7
            //dateInfo.minute = 0
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: "updateCategory", content: content, trigger: trigger)
            
            // Schedule the request.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
            
            /*let notification = UILocalNotification()
            notification.category = applicationContext["updateCategory"] as? String
            notification.alertTitle = applicationContext["alertTitle"] as? String
            notification.alertBody = applicationContext["alertBody"] as? String
            notification.fireDate = applicationContext["fireDate"] as? Date
            notification.soundName = applicationContext["soundName"] as? String
            if let badge = applicationContext["applicationIconBadgeNumber"] as? Int {
                notification.applicationIconBadgeNumber = badge
            }
            //notification.soundName = userInfo?["soundName"] as? String
            
            UIApplication.shared.scheduleLocalNotification(notification)*/
            
            //UIApplication.shared.registerForRemoteNotifications(matching: notification)
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let tableViewController = window?.rootViewController as! TableViewController
        
        print("Siri running shortcut dropPin...")
        
        tableViewController.siri()
        
        return true
    }
    
}

