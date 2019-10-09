//
//  TodayViewController.swift
//  Drop a Pin
//
//  Created by Eric Cook on 3/27/18.
//  Copyright © 2018 Better Search, LLC. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import MessageUI
//import WatchKit
//import WatchConnectivity
import UserNotifications


var manager2:CLLocationManager!
var myLocations2: [CLLocation] = []

var daddr2 = String()

var XRP2 = String()

var BTC2 = String()

var XMR2 = String()

@available(iOS 10.0, *)
class TodayViewController: UIViewController, NCWidgetProviding,  CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {  //WCSessionDelegate,
    
    /*func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }*/
    
    
    //let session = WCSession.default
    
    var iPathEmail = [String]()
    var iPathText = [String]()
    
    @IBOutlet var locationText: UILabel!
    @IBOutlet var crypto: UILabel!
    
    var timer : Timer?
    
    @IBAction func textLocation(_ sender: Any) {
        
        sendText()
        
    }
    
    
    @IBAction func emailLocation(_ sender: Any) {
        
        sendEmail()
    }
    
    
    @IBAction func openApp(_ sender: Any) {
        
        let url:URL = URL(string: "dropapin://")!
        //let url:NSURL = NSURL(string: "Maps://")!
        extensionContext?.open(url, completionHandler: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
        }*/
        
        prices()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
       
        manager2 = CLLocationManager()
        manager2.delegate = self
        manager2.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func prices() {
        
        self.crypto.text = ""
        
        let coins = ["BTC","XRP","XMR"]
        
        UserDefaults.standard.removeObject(forKey: "BTC")
        
        UserDefaults.standard.removeObject(forKey: "XRP")
        
        UserDefaults.standard.removeObject(forKey: "XMR")
        
        var BTC1 = Double()
        var XRP1 = Double()
        var XMR1 = Double()
        
        for coin in coins {
            
            do {
                
                if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(coin)&tsyms=USD") {
                    
                    let data = try Data(contentsOf: url)
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let object = json as? [String: Double] {
                        
                        if let price = object["USD"] {
                            
                            print(price)
                            
                            let coinPrice = "\(coin): $\(price)"
                            
                            print(coinPrice)
                            
                            UserDefaults.standard.set(price, forKey: coin)
                            
                            if coin == "BTC" {
                                
                                BTC1 = UserDefaults.standard.double(forKey: "BTC")
                                
                                print(BTC1)
                            }
                            
                            if coin == "XRP" {
                                
                                XRP1 = UserDefaults.standard.double(forKey: "XRP")
                                
                                print(XRP1)
                                
                            }
                            
                            if coin == "XMR" {
                                
                                XMR1 = UserDefaults.standard.double(forKey: "XMR")
                                
                                print(XMR1)
                                
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
        
        BTC2 = String(format: "%.2f", BTC1)
        
        XRP2 = String(format: "%.4f", XRP1)
        
        XMR2 = String(format: "%.2f", XMR1)
        
        self.crypto.text = "BTC: $\(BTC2)\rXRP: $\(XRP2)\rXMR: $\(XMR2)"
        
        /*if let url = URL(string: "https://coinmarketcap.com/currencies/ripple/") {
            
            do {
                //XRP
                let contents = try String(contentsOf: url)
                
                let matched = matches(for: "<span id=\"quote_price\" data-currency-price data-usd=\".+", in: contents)
                
                let snippet = "\(matched)"
                
                let indexStartOfText = snippet.index(snippet.startIndex, offsetBy: 58)
                let indexEndOfText = snippet.index(snippet.endIndex, offsetBy: -7)
                
                let substring1 = snippet[indexStartOfText..<indexEndOfText]
                let XRP1 = "\(substring1)"
                //XRP1 = String(format: "%.2f", XRP1)
                //BTC
                let url2 = URL(string: "https://coinmarketcap.com/currencies/bitcoin/")
                let contents2 = try String(contentsOf: url2!)
                let matched2 = matches(for: "<span id=\"quote_price\" data-currency-price data-usd=\".+", in: contents2)
                
                let snippet2 = "\(matched2)"
                
                let indexStartOfText2 = snippet2.index(snippet2.startIndex, offsetBy: 58)
                let indexEndOfText2 = snippet2.index(snippet2.endIndex, offsetBy: -5)
                
                let substring2 = snippet2[indexStartOfText2..<indexEndOfText2]
                let BTC1 = "\(substring2)"
                //BTC1 = String(format: "%.2f", BTC1)
                
                //Monero XMR
                let url3 = URL(string: "https://coinmarketcap.com/currencies/monero/")
                let contents3 = try String(contentsOf: url3!)
                let matched3 = matches(for: "<span id=\"quote_price\" data-currency-price data-usd=\".+", in: contents3)
                
                let snippet3 = "\(matched3)"
                
                let indexStartOfText3 = snippet3.index(snippet3.startIndex, offsetBy: 58)
                let indexEndOfText3 = snippet3.index(snippet3.endIndex, offsetBy: -5)
                
                let substring3 = snippet3[indexStartOfText3..<indexEndOfText3]
                let XMR1 = "\(substring3)"
                
                let numXRP = Double(XRP1)
                XRP2 = String(format: "%.3f", numXRP!)
                
                let numBTC = Double(BTC1)
                BTC2 = String(format: "%.2f", numBTC!)
                
                let numXMR = Double(XMR1)
                XMR2 = String(format: "%.2f", numXMR!)
                
                self.crypto.text = "BTC: $\(BTC2)\rXRP: $\(XRP2)\rXMR: $\(XMR2)"
                
                //sendPriceUpdateToWatch()
                
            } catch {
                // contents could not be loaded
                self.crypto.text = "We could not get the current prices."
            }
        } else {
            // the URL was bad!
            self.crypto.text = "We could not connect to Coin Market."
        }*/
        
    }
    
    /*func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }*/
    
   
    override func viewDidAppear(_ animated: Bool) {
        
       /* let defaults = UserDefaults(suiteName: "group.bettersearchllc.sharewidgetplace")
        let defaultValue = [String:String]()
        defaults!.register(defaults: defaultValue)
        defaults!.set(defaultValue, forKey: "place")
        defaults!.synchronize()*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        findLocation()
        
    }
    
    func findLocation() {
        
        let latitude:CLLocationDegrees = manager2.location!.coordinate.latitude
        let longitude:CLLocationDegrees = manager2.location!.coordinate.longitude
        
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
                
                self.locationText.text = title
                
                let defaults = UserDefaults(suiteName: "group.bettersearchllc.sharewidgetplace")
                let defaultValue = ["name":"\(title)","lat":"\(latitude)","lon":"\(longitude)"]
                defaults!.register(defaults: defaultValue)
                defaults!.set(defaultValue, forKey: "place")
                defaults!.synchronize()
               
                print(defaults!)
                
                daddr2 = "\(title1)"
                //print("\(title1)")
                
                 /*if (subThoroughfare == "39" && thoroughfare == "Taconic Rd" && zip ==  "10562") {
                    
                    self.locationText.text = "You are home!"
                    
                }*/
                
                if (thoroughfare == "Log Cabin Way" && zip ==  "10504") {
                    
                     self.locationText.text = "Gate Code 8153."
                    
                }
                
                if (subThoroughfare == "2" && thoroughfare == "Agnew Farm Rd" && zip ==  "10504") {
                    
                     self.locationText.text = "Pool Code 421."
                    
                }
            }
            
            
        })
        
    }
    
    func sendText() {  //Price Button
        
        prices()
        
        /*let messageVC = MFMessageComposeViewController()
        
        messageVC.recipients = iPathText
        
        messageVC.subject = "Here is my location!";
        messageVC.body =  "Google Maps: \n https://www.google.com/maps/place/" + daddr2 + "\n\n Waze: \n http://waze.to/?q=" + daddr2 + "\n\n Apple Maps: \n http://maps.apple.com/maps?saddr=&daddr=" + daddr2
        
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)*/
        
    }
    
    func sendEmail() {
        
        let toRecipents = iPathEmail  //iPathEmail
        //var toRecipents: [String] = iPathEmail as [String]
        print(toRecipents)
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setSubject("Here is my location!")
        
        mc.setMessageBody("<p>Google Maps: </p><p> https://www.google.com/maps/place/" + daddr2 + "</p><p> Waze: </p><p> http://waze.to/?q=" + daddr2 + "</p><p> Apple Maps: </p><p> http://maps.apple.com/maps?saddr=&daddr=" + daddr2 + "</p>", isHTML: true)
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
        
        //tasksTable.reloadData()
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
        //tasksTable.reloadData()
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.noData)
        
        
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        let newInsets = UIEdgeInsets(top: defaultMarginInsets.top, left: defaultMarginInsets.left-15,
                                     bottom: defaultMarginInsets.bottom, right: defaultMarginInsets.right)
        return newInsets
    }

}




