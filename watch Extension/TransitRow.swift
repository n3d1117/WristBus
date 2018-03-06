//
//  TransitRowController.swift
//  ataf
//
//  Created by ned on 26/11/2016.
//  Copyright © 2016 ned. All rights reserved.
//

import WatchKit

class TransitRow: NSObject {
    
    @IBOutlet var line: WKInterfaceLabel!
    @IBOutlet var time: WKInterfaceLabel!
    @IBOutlet var separator: WKInterfaceSeparator!
    
    var randomColor : UIColor {
        if let transit = transit {
            switch transit.line {
                
                // Some known lines
                
                case "8": return UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0)
                case "31": return UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0)
                case "23": return UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0)
                case "6A": return UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
                case "6B": return UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0)
                case "14CB": return UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0)
                case "60": return UIColor.magenta
                default: return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
            }
        }
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
    
    var transit: Transit? {
        didSet {
            if let transit = transit {
                line.setText("LINEA " + transit.line)
                time.setText(transit.time)
                
                let color = randomColor
                time.setTextColor(color)
                separator.setColor(color)
            }
        }
    }
}
