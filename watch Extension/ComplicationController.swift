//
//  ComplicationController.swift
//  watch Extension
//
//  Created by ned on 05/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        let modularTemplate = CLKComplicationTemplateModularSmallSimpleImage()
        let image = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
        image.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172/255.0, alpha: 1)
        modularTemplate.imageProvider = image
        modularTemplate.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172.0/255.0, alpha: 1)
        let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modularTemplate)
        handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let modularTemplate = CLKComplicationTemplateModularSmallSimpleImage()
        let image = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
        image.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172/255.0, alpha: 1)
        modularTemplate.imageProvider = image
        modularTemplate.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172.0/255.0, alpha: 1)
        handler(modularTemplate)
    }
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let modularTemplate = CLKComplicationTemplateModularSmallSimpleImage()
        let image = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
        image.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172/255.0, alpha: 1)
        modularTemplate.imageProvider = image
        modularTemplate.tintColor = UIColor(red: 83.0/255.0, green: 74.0/255.0, blue: 172.0/255.0, alpha: 1)
        handler(modularTemplate)
    }
    
}
