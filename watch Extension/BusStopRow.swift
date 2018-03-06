//
//  BusStopRowController.swift
//  ataf
//
//  Created by ned on 26/11/2016.
//  Copyright © 2016 ned. All rights reserved.
//

import WatchKit

class BusRow: NSObject {
    @IBOutlet var name: WKInterfaceLabel!
    
    var stop: BusStop? {
        didSet {
            if let stop = stop {
                name.setText(stop.name)
            }
        }
    }
}
