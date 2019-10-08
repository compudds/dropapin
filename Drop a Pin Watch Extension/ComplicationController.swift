//
//  ComplicationController.swift
//  Drop a Pin Watch Extension
//
//  Created by Eric Cook on 4/8/18.
//  Copyright © 2018 Appfish. All rights reserved.
//

import ClockKit
import WatchKit
//import UserNotifications

var XRP2 = String()

var BTC2 = String()

var XMR2 = String()

@available(watchOSApplicationExtension 5.0, *)
class ComplicationController: NSObject, CLKComplicationDataSource {

    
    //---multipliers to convert to seconds---
    let HOUR: TimeInterval = 60 * 60
    let MINUTE: TimeInterval = 60
    
    
    func updateCurrentTime() -> String {
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        // get the date time String from the date object
        let updatedTime = formatter.string(from: currentDateTime)
        
        return updatedTime
    }
    
    func updateCurrentDate() -> String {
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        let updatedDate = formatter.string(from: currentDateTime)
        
        return updatedDate
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        //handler([.forward, .backward])
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
        /*let date = Calendar.current.startOfDay(for: Date())
        print("Timeline start date :\(date)")
        handler(date)*/
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
        /*var  date = Calendar.current.startOfDay(for: Date())
        date = Calendar.current.date(byAdding: .day, value: 2, to: date)!
        print("Timeline end date:\(date)")
        
        handler(date)*/
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        if complication.family == .circularSmall
        {
            
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
            /*let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Circular"))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)*/
            
        } else if complication.family == .utilitarianSmall
        {
            
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
            
            /*let template = CLKComplicationTemplateUtilitarianSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Utilitarian"))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)*/
            
        } else if complication.family == .modularSmall
        {
           
            /*let image: UIImage = #imageLiteral(resourceName: "Complication/Modular")
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)*/
            
            let template = CLKComplicationTemplateModularSmallColumnsText()
            //template.textProvider = CLKSimpleTextProvider(text: "Drop")
            //template.tintColor = UIColor.red
            //template.highlightColumn2 = true
            //template.column2Alignment = CLKComplicationColumnAlignment(rawValue: 0)!
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: BTC2)
            template.row1Column2TextProvider.tintColor = UIColor.orange
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "R")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: XRP2)
            template.row2Column2TextProvider.tintColor = UIColor.cyan
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
        } else if complication.family == .modularLarge
        {
            
            let template = CLKComplicationTemplateModularLargeColumns()
            //template.row1ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row2ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row3ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            
            //template.row1Column1TextProvider = CLKSimpleTextProvider(text: "\(newPlace)")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$\(BTC2)")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Ripple")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$\(XRP2)")
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentDate())")
            template.row3Column1TextProvider.tintColor = UIColor.yellow
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentTime())")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
        } else if complication.family == .graphicCorner
        {
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "B \(BTC2)")
            template.outerTextProvider.tintColor = UIColor.cyan
            template.innerTextProvider = CLKSimpleTextProvider(text: "R \(XRP2) \(updateCurrentTime())")
            template.innerTextProvider.tintColor = UIColor.yellow
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
        } else if complication.family == .graphicRectangular
        {
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$\(BTC2)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "R: $\(XRP2) \(updateCurrentTime())")
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
        } else if complication.family == .graphicBezel
        {
            let templateCircular = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            templateCircular.centerTextProvider = CLKSimpleTextProvider(text: "B \(BTC2)")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            templateCircular.gaugeProvider = gaugeProviderRing
            
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: "R \(XRP2) \(updateCurrentTime())")
            template.circularTemplate = templateCircular
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
        } else if complication.family == .graphicCircular
        {
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "DP")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            template.gaugeProvider = gaugeProviderRing
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
            
 
            
        } else {
            
            handler(nil)
            
        }
        
    }
    
    /*func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        
        
        updateComplicationPrices()
        
        if complication.family == .modularLarge {
            
            let template = CLKComplicationTemplateModularLargeColumns()
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$\(newBTC2)")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Ripple")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$\(newXRP2)")
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentDate())")
            template.row3Column1TextProvider.tintColor = UIColor.yellow
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentTime())")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
            
        } else if complication.family == .modularSmall {
            
            let template = CLKComplicationTemplateModularSmallColumnsText()
            //template.textProvider = CLKSimpleTextProvider(text: "Drop")
            //template.tintColor = UIColor.red
            //template.highlightColumn2 = true
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: newBTC2)
            template.row1Column2TextProvider.tintColor = UIColor.orange
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "R")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: newXRP2)
            template.row2Column2TextProvider.tintColor = UIColor.cyan
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicCorner
        {
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "B \(newBTC2)")
            template.outerTextProvider.tintColor = UIColor.cyan
            //template.trailingTextProvider = CLKSimpleTextProvider(text: "M: \(newXMR2)")
            //template.trailingTextProvider!.tintColor = UIColor.yellow
            template.innerTextProvider = CLKSimpleTextProvider(text: "R \(newXRP2) \(updateCurrentTime())")
            template.innerTextProvider.tintColor = UIColor.yellow
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicRectangular
        {
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$\(newBTC2)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "R: $\(newXRP2) \(updateCurrentTime())")
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicBezel
        {
            let templateCircular = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            templateCircular.centerTextProvider = CLKSimpleTextProvider(text: "B \(newBTC2)")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            templateCircular.gaugeProvider = gaugeProviderRing
            
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: "R \(newXRP2) \(updateCurrentTime())")
            template.circularTemplate = templateCircular
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicCircular
        {
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "DP")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            template.gaugeProvider = gaugeProviderRing
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
 
            
        } else {
            
             handler(nil)
            
        }
        
        
       
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        
        updateComplicationPrices()
        
        if complication.family == .modularLarge {
            
            let template = CLKComplicationTemplateModularLargeColumns()
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$\(newBTC2)")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Ripple")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$\(newXRP2)")
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentDate())")
            template.row3Column1TextProvider.tintColor = UIColor.yellow
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentTime())")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
            
        } else if complication.family == .modularSmall {
            
            let template = CLKComplicationTemplateModularSmallColumnsText()
            //template.textProvider = CLKSimpleTextProvider(text: "Drop")
            //template.tintColor = UIColor.red
            //template.highlightColumn2 = true
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: newBTC2)
            template.row1Column2TextProvider.tintColor = UIColor.orange
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "R")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: newXRP2)
            template.row2Column2TextProvider.tintColor = UIColor.cyan
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicCorner
        {
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "B \(newBTC2)")
            template.outerTextProvider.tintColor = UIColor.cyan
            //template.trailingTextProvider = CLKSimpleTextProvider(text: "M: \(newXMR2)")
            //template.trailingTextProvider!.tintColor = UIColor.yellow
            template.innerTextProvider = CLKSimpleTextProvider(text: "R \(newXRP2) \(updateCurrentTime())")
            template.innerTextProvider.tintColor = UIColor.yellow
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicRectangular
        {
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$\(newBTC2)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "R: $\(newXRP2) \(updateCurrentTime())")
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicBezel
        {
            let templateCircular = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            templateCircular.centerTextProvider = CLKSimpleTextProvider(text: "B \(newBTC2)")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            templateCircular.gaugeProvider = gaugeProviderRing
            
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: "R \(newXRP2) \(updateCurrentTime())")
            template.circularTemplate = templateCircular
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
            
        } else if complication.family == .graphicCircular
        {
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "DP")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            template.gaugeProvider = gaugeProviderRing
            template.tintColor = UIColor.red
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 3), complicationTemplate: template)
            
            handler([timelineEntry])
 
            
        } else {
            
            handler(nil)
            
        }
        
    }
    */
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch complication.family
        {
        case .circularSmall:
            
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            handler(template)
            
            
            /*let image: UIImage = #imageLiteral(resourceName: "Complication/Circular")
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)*/
            
        case .utilitarianSmall:
            
            
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            handler(template)
            
            
            /*let image: UIImage = #imageLiteral(resourceName: "Complication/Utilitarian")
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)*/
            
        case .modularSmall:
            
            let template = CLKComplicationTemplateModularSmallColumnsText()
            //template.textProvider = CLKSimpleTextProvider(text: "Drop")
            //template.tintColor = UIColor.red
            //template.highlightColumn2 = true
            template.column2Alignment = CLKComplicationColumnAlignment(rawValue: 0)!
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$____.__")
             template.row1Column2TextProvider.tintColor = UIColor.orange
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "R")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$__.__")
            template.row2Column2TextProvider.tintColor = UIColor.cyan
            handler(template)
            
            
            /*let image: UIImage = #imageLiteral(resourceName: "Complication/Modular")
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)*/
            
        case .modularLarge:
            
            let template = CLKComplicationTemplateModularLargeColumns()
            //template.row1ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row2ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row3ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
           
            //template.row1Column1TextProvider = CLKSimpleTextProvider(text: "\(newPlace)")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$____.__")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Ripple")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$____.__")
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "Update")
            template.row3Column1TextProvider.tintColor = UIColor.yellow
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "__:__")
            handler(template)
            
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "B: $____.__")
            template.outerTextProvider.tintColor = UIColor.cyan
            //template.trailingTextProvider = CLKSimpleTextProvider(text: "M: \(newXMR2)")
            //template.trailingTextProvider!.tintColor = UIColor.yellow
            template.innerTextProvider = CLKSimpleTextProvider(text: "R: $____.__ Up: __:__")
            template.innerTextProvider.tintColor = UIColor.yellow
            handler(template)
            
            
        case .graphicBezel:
            let templateCircular = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            templateCircular.centerTextProvider = CLKSimpleTextProvider(text: "B $____.__")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            templateCircular.gaugeProvider = gaugeProviderRing
            
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: "R $____.__ Up: __:__")
            template.circularTemplate = templateCircular
            template.tintColor = UIColor.red
            handler(template)
        
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "DP")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            template.gaugeProvider = gaugeProviderRing
            template.tintColor = UIColor.red
            handler(template)
        
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$____.__")
            template.body2TextProvider = CLKSimpleTextProvider(text: "R: $____.__ Up: __:__")
            template.tintColor = UIColor.red
            handler(template)
            
        default:
            handler(nil)
        }
        
       
    }
    
    
    func getPlaceholderTemplateForComplication( complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and
        // the results will be cached
        
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
            
        case .modularSmall:
            /*let template = CLKComplicationTemplateModularSmallSimpleImage()
            let icon = #imageLiteral(resourceName: "Complication/Modular")
            template.imageProvider = CLKImageProvider(onePieceImage: icon)
            handler(template)*/
            
            let template = CLKComplicationTemplateModularSmallColumnsText()
            //template.textProvider = CLKSimpleTextProvider(text: "Drop")
            //template.tintColor = UIColor.red
            //template.highlightColumn2 = true
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: BTC2)
            template.row1Column2TextProvider.tintColor = UIColor.orange
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "R")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: XRP2)
            template.row2Column2TextProvider.tintColor = UIColor.cyan
            handler(template)
            
            /*let modularSmallTemplate =
                CLKComplicationTemplateModularSmallRingText()
            modularSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: "D")
            modularSmallTemplate.fillFraction = 0.75
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            template = modularSmallTemplate*/
            
            
        case .modularLarge:
            
            let template = CLKComplicationTemplateModularLargeColumns()
            //template.row1ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row2ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            //template.row3ImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: ""))
            
            //template.row1Column1TextProvider = CLKSimpleTextProvider(text: "\(newPlace)")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.row1Column1TextProvider.tintColor = UIColor.orange
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "$\(BTC2)")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Ripple")
            template.row2Column1TextProvider.tintColor = UIColor.cyan
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "$\(XRP2)")
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentDate())")
            template.row3Column1TextProvider.tintColor = UIColor.yellow
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "\(updateCurrentTime())")
            handler(template)
            
            
        case .utilitarianSmall:
            
            
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            handler(template)
            
            
            /*let template = CLKComplicationTemplateUtilitarianSmallRingImage()
            let icon = #imageLiteral(resourceName: "Complication/Utilitarian")
            template.imageProvider = CLKImageProvider(onePieceImage: icon)
            handler(template)*/
            
        case .utilitarianLarge:
            
            template = nil
        
        case .circularSmall:
            
            
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            handler(template)
            
            
            /*let icon = #imageLiteral(resourceName: "Complication/Circular")
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = CLKImageProvider(onePieceImage: icon)
            handler(template)*/
       
        case .utilitarianSmallFlat:
            
            
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: "DP")
            template.tintColor = UIColor.red
            handler(template)
            
            
            /*let template = CLKComplicationTemplateUtilitarianSmallRingImage()
            let icon = #imageLiteral(resourceName: "Complication/Utilitarian")
            template.imageProvider = CLKImageProvider(onePieceImage: icon)
            handler(template)*/
            
        case .extraLarge:
            
            template = nil
            
        case .graphicCorner:
            
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "B \(BTC2)")
            template.outerTextProvider.tintColor = UIColor.cyan
            template.innerTextProvider = CLKSimpleTextProvider(text: "R \(XRP2) \(updateCurrentTime())")
            template.innerTextProvider.tintColor = UIColor.yellow
            handler(template)
            
        case .graphicBezel:
            
            let templateCircular = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            templateCircular.centerTextProvider = CLKSimpleTextProvider(text: "B \(BTC2)")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
                
            )
            templateCircular.gaugeProvider = gaugeProviderRing
            
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: "R \(XRP2) \(updateCurrentTime())")
            template.circularTemplate = templateCircular
            template.tintColor = UIColor.red
            handler(template)
        
        case .graphicCircular:
            
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "DP")
            let gaugeProviderRing = CLKSimpleGaugeProvider(
                style: .ring,
                gaugeColor: UIColor.yellow,
                fillFraction: 1.0
            
            )
            template.gaugeProvider = gaugeProviderRing
            template.tintColor = UIColor.red
            handler(template)
            
            
        case .graphicRectangular:
           
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Bitcoin")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$\(BTC2)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "R: $\(XRP2) \(updateCurrentTime())")
            template.tintColor = UIColor.red
            handler(template)
      
        /*case .graphicBezel:
            template = nil
        case .graphicCircular:
           template = nil
        case .graphicRectangular:
           template = nil*/
            
        default:
            handler(nil)
        }
        handler(template)
        
    }
    
}
    

