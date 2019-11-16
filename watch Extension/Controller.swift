//
//  InterfaceController.swift
//  watch Extension
//
//  Created by ned on 05/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class Controller: WKInterfaceController {

    @IBOutlet weak var stopsTable: WKInterfaceTable!
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    var stops: [BusStop] { return BusStop.allStops() }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        processApplicationContext()
        
        session?.delegate = self
        session?.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let session = session {
            switch session.activationState {
                case .inactive, .notActivated: session.activate()
                default: break
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let stop = stops[rowIndex]
        pushController(withName: "Detail", context: stop)
    }
    
    func processApplicationContext() {
        if let context = session?.receivedApplicationContext {
            if let c = context as? [String: String] {
                if !c.isEmpty {
                    BusStop.saveStopsLocally(from: c)
                }
                stopsTable.setNumberOfRows(stops.count, withRowType: "stop_row")
                for index in 0..<stops.count {
                    if let controller = stopsTable.rowController(at: index) as? BusRow {
                        controller.stop = stops[index]
                    }
                }
            }
        }
    }
    
}

extension Controller: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.processApplicationContext()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
