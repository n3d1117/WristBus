//
//  Detail.swift
//  ataf
//
//  Created by ned on 30/11/2016.
//  Copyright © 2016 ned. All rights reserved.
//

import WatchKit
import Foundation

class Detail: WKInterfaceController {

    @IBOutlet weak var transitsTable: WKInterfaceTable!
    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var sadLabel: WKInterfaceLabel!
    
    var stop : BusStop?
    
    var isLoading : Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let stop = context as? BusStop { self.stop = stop; self.setTitle(self.stop?.node) }
        addMenuItem(with: .repeat, title: "Refresh", action: #selector(self.loadTransits))
        self.loadTransits()
    }
    
    override func didAppear() {
        super.didAppear()
        
    }
    
    @objc func loadTransits() {
        if let stop = self.stop {
            
            isLoading = true
            
            var arr = [Int]()
            for i in 0..<transitsTable.numberOfRows { arr.append(i) }
            transitsTable.removeRows(at: IndexSet(arr))
            
            backgroundGroup.setBackgroundImageNamed("Activity")
            backgroundGroup.startAnimatingWithImages(in: NSRange(location: 0, length: 30), duration: 0.5, repeatCount: 15)
            
            Network.request(node: stop.node) { busStop in
                self.stop?.transits = busStop.transits
                
                self.backgroundGroup.stopAnimating()
                self.backgroundGroup.setBackgroundImage(nil)
                
                if stop.transits.isEmpty {
                    self.sadLabel.setText("😥")
                } else {
                    self.transitsTable.setNumberOfRows(stop.transits.count, withRowType: "transit_row")
                    for index in 0..<stop.transits.count {
                        if let controller = self.transitsTable.rowController(at: index) as? TransitRow {
                            controller.transit = stop.transits[index]
                        }
                    }
                }
                
                self.isLoading = false
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if !isLoading {
            self.loadTransits()
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
